//
//  FileManagerWrapper.swift
//
//
//  Created by fuziki on 2022/04/24.
//

import Foundation

public enum DirectoryType {
    case caches
    case document
}

public enum FileManagerWrapperError: Error {
    case noDirectory
}

public protocol FileManagerWrapper {
    func url(directory: DirectoryType) throws -> URL
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws
}

public class DefaultFileManagerWrapper: FileManagerWrapper {
    public init() {
    }

    public func url(directory: DirectoryType) throws -> URL {
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
    public func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws {
        try FileManager.default.createDirectory(at: url,
                                                withIntermediateDirectories: createIntermediates,
                                                attributes: [:])
    }
}
