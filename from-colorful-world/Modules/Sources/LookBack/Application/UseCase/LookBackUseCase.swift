//
//  LookBackUseCase.swift
//
//
//  Created by fuziki on 2022/05/04.
//

import Core
import Foundation

public class LookBackUseCase {

    // Injected
    private let fileManager: FileManagerWrapper

    // Properties
    private var detectedCache: [String: Set<Int>] = [:]

    public init(fileManager: FileManagerWrapper) {
        self.fileManager = fileManager
    }
    private func getDirectoryUrl(calendar: Calendar, timeZone: TimeZone, date: Date) -> URL? {
        let component = calendar.dateComponents(in: timeZone, from: date)
        guard let year = component.year,
              let month = component.month,
              let day = component.day else {
            return nil
        }
        let docUrl: URL
        do {
            docUrl = try fileManager.url(directory: .document)
        } catch let error {
            print("error: \(error)")
            return nil
        }
        return docUrl
            .appendingPathComponent("保存された結果", isDirectory: true)
            .appendingPathComponent("\(year)", isDirectory: true)
            .appendingPathComponent("\(month)", isDirectory: true)
            .appendingPathComponent("\(day)", isDirectory: true)
    }
}

extension LookBackUseCase: LookBackReadUseCaseProtocol {
    func getAssignmentTitleList(calendar: Calendar, timeZone: TimeZone, date: Date) -> [String] {
        guard let dir = getDirectoryUrl(calendar: calendar, timeZone: timeZone, date: date),
              // ディレクトリが無い場合にエラーになるので握り潰す
              let contents = try? fileManager.contentsOfDirectory(at: dir) else {
            return []
        }
        return contents.map { $0.deletingPathExtension().lastPathComponent }
    }

    func getDayResult(calendar: Calendar, timeZone: TimeZone, date: Date) -> [(title: String, ok: [Bool])] {
        guard let dir = getDirectoryUrl(calendar: calendar, timeZone: timeZone, date: date),
              // ディレクトリが無い場合にエラーになるので握り潰す
              let contents = try? fileManager.contentsOfDirectory(at: dir) else {
            return []
        }
        let csvs = contents.filter { $0.pathExtension == "csv" }
        return csvs.compactMap { (url: URL) -> (title: String, ok: [Bool])? in
            let title = url.deletingPathExtension().lastPathComponent
            var current: String
            do {
                current = try fileManager.readString(url: url)
            } catch let error {
                print("error: \(error)")
                return nil
            }
            current = current.replacingOccurrences(of: "\r", with: "")
            let indexes = current.components(separatedBy: "\n")
            let ok = indexes.map { $0 == "1" }
            return (title: title, ok: ok)
        }
    }
}

extension LookBackUseCase: LookBackWriteUseCaseProtocol {
    public func detected(title: String, index: Int) {
        var current = detectedCache[title] ?? []
        current.insert(index)
        detectedCache[title] = current
    }

    public func save(classPeaples: Int, calendar: Calendar, timeZone: TimeZone, date: Date) {
        guard let dir = getDirectoryUrl(calendar: calendar, timeZone: timeZone, date: date) else { return }
        let contents: [URL]
        do {
            try fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
            contents = try fileManager.contentsOfDirectory(at: dir)
        } catch let error {
            print("error: \(error)")
            return
        }
        let csvs = contents.filter { $0.pathExtension == "csv" }
        detectedCache.forEach { (key: String, value: Set<Int>) in
            if let existed = csvs.first(where: { $0.deletingPathExtension().lastPathComponent == "\(key)" }) {
                merge(classPeaples: classPeaples, existed: existed, detected: value)
            } else {
                write(classPeaples: classPeaples, dir: dir, title: key, detected: value)
            }
        }
        detectedCache = [:]
    }

    private func merge(classPeaples: Int, existed: URL, detected: Set<Int>) {
        var current: String
        do {
            current = try fileManager.readString(url: existed)
        } catch let error {
            print("error: \(error)")
            return
        }
        current = current.replacingOccurrences(of: "\r", with: "")
        let indexes = current.components(separatedBy: "\n")
        print("indexes: \(indexes)")
        let res = (0..<classPeaples).map { (i: Int) -> String in
            let ex = indexes[safe: i] == "1"
            let dt = detected.contains(i + 1)
            return (ex || dt) ? "1" : "0"
        }
        let str = res.joined(separator: "\r\n")
        do {
            try fileManager.writeString(string: str, url: existed)
        } catch let error {
            print("error: \(error)")
        }
    }

    private func write(classPeaples: Int, dir: URL, title: String, detected: Set<Int>) {
        let res = (0..<classPeaples).map { (i: Int) -> String in
            let dt = detected.contains(i + 1)
            return dt ? "1" : "0"
        }
        let str = res.joined(separator: "\r\n")
        let url = dir.appendingPathComponent("\(title).csv", isDirectory: false)
        do {
            try fileManager.writeString(string: str, url: url)
        } catch let error {
            print("error: \(error)")
        }
    }
}
