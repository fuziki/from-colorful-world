//
//  LookBackUseCaseTest.swift
//  
//
//  Created by fuziki on 2022/05/06.
//

import Core
import XCTest
@testable import LookBack

final class LookBackUseCaseTest: XCTestCase {
    func testWrite() {
        let fileManager = MockedFileManagerWrapper()
        let usecase = LookBackUseCase(fileManager: fileManager)
        
        usecase.detected(title: "Fuga", index: 3)
        usecase.save(classPeaples: 4, calendar: .current, timeZone: .current, date: Date())

        XCTAssertEqual(fileManager.writtenString, "0\r\n0\r\n1\r\n0")
    }

    func testMerge() {
        let fileManager = MockedFileManagerWrapper()
        let usecase = LookBackUseCase(fileManager: fileManager)
        
        usecase.detected(title: "Hoge", index: 3)
        usecase.save(classPeaples: 4, calendar: .current, timeZone: .current, date: Date())

        XCTAssertEqual(fileManager.writtenString, "1\r\n0\r\n1\r\n0")
    }
    
    func testTitleList() {
        let fileManager = MockedFileManagerWrapper()
        let usecase = LookBackUseCase(fileManager: fileManager)

        let titles = usecase.getAssignmentTitleList(calendar: .current, timeZone: .current, date: Date())
        
        XCTAssertEqual(titles, ["Hoge", "HogeHoge"])
    }
    
    func testDayResult() {
        let fileManager = MockedFileManagerWrapper()
        let usecase = LookBackUseCase(fileManager: fileManager)

        let res = usecase.getDayResult(calendar: .current, timeZone: .current, date: Date())

        XCTAssertEqual(res.count, 2)
        XCTAssertEqual(res[0].title, "Hoge")
        XCTAssertEqual(res[0].ok, [true, false])
    }
}

class MockedFileManagerWrapper: FileManagerWrapper {
    func url(directory: DirectoryType) throws -> URL {
        return URL(string: "/docs")!
    }
    
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws {
    }
    
    func contentsOfDirectory(at url: URL) throws -> [URL] {
        return [
            URL(string: "/docs/Hoge.csv")!,
            URL(string: "/docs/HogeHoge.csv")!,
        ]
    }
    
    func readString(url: URL) throws -> String {
        return "1\r\n0"
    }
    
    var writtenString: String? = nil
    func writeString(string: String, url: URL) throws {
        writtenString = string
    }
}
