//
//  FileManagerWrapper.swift
//
//
//  Created by fuziki on 2022/04/24.
//

import Foundation

enum DirectoryType {
    case caches
    case document
}

enum FileManagerWrapperError: Error {
    case noDirectory
}

protocol FileManagerWrapper {
    func url(directory: DirectoryType) throws -> URL
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws
}

class DefaultFileManagerWrapper: FileManagerWrapper {
    func url(directory: DirectoryType) throws -> URL {
        let search: FileManager.SearchPathDirectory
        switch directory {
        case .caches:
            search = .cachesDirectory
        case .document:
            search = .documentDirectory
        }
        guard let url = FileManager.default
                .urls(for: search, in: .userDomainMask)
                .first else {
            throw FileManagerWrapperError.noDirectory
        }
        return url
    }
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws {
        try FileManager.default.createDirectory(at: url,
                                                withIntermediateDirectories: createIntermediates,
                                                attributes: [:])
    }
}
