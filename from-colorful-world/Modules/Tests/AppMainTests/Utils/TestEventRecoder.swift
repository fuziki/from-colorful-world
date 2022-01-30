//
//  TestEventRecoder.swift
//  
//
//  Created by fuziki on 2022/01/30.
//

import AppleExtensions
import Combine
import CombineSchedulers
import XCTest

class TestEventRecoder<Output, SchedulerTimeType, SchedulerOptions, TestSchedulerType>
        where Output: Equatable,
              SchedulerTimeType: Strideable,
              SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible,
              TestSchedulerType: TestScheduler<SchedulerTimeType, SchedulerOptions> {
    struct LineAssertEventRecorded: CustomDebugStringConvertible, Equatable {
        public let time: TestSchedulerType.SchedulerTimeType
        public let output: Output
        public let file: StaticString
        public let line: UInt
        init(time: TestSchedulerType.SchedulerTimeType, output: Output, file: StaticString = #file, line: UInt = #line) {
            self.time = time
            self.output = output
            self.file = file
            self.line = line
        }
        public static func onNext(_ time: TestSchedulerType.SchedulerTimeType, _ output: Output,
                                  file: StaticString = #file, line: UInt = #line) -> LineAssertEventRecorded {
            return .init(time: time, output: output, file: file, line: line)
        }
        public var debugDescription: String {
            return "@\(time): \(output)"
        }
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.time == rhs.time && lhs.output == rhs.output
        }
    }

    private let testScheduler: TestSchedulerType
    
    public init(outputType: Output.Type, testScheduler: TestSchedulerType) {
        self.testScheduler = testScheduler
    }
    
    public private(set) var eventRecorded: [LineAssertEventRecorded] = []
    
    public func send(_ output: Output) {
        eventRecorded.append(.init(time: testScheduler.now, output: output))
    }
}

func XCTAssertEqual<Output,
                    SchedulerTimeType,
                    SchedulerOptions,
                    TestSchedulerType,
                    TestSubjectType>(_ left: [TestSubjectType.LineAssertEventRecorded],
                                     lineAssertReferences: [TestSubjectType.LineAssertEventRecorded],
                                     file: StaticString = #file,
                                     line: UInt = #line)
        where Output: Equatable,
              SchedulerTimeType: Strideable,
              SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible,
              TestSchedulerType: TestScheduler<SchedulerTimeType, SchedulerOptions>,
              TestSubjectType: TestEventRecoder<Output, SchedulerTimeType, SchedulerOptions, TestSchedulerType> {
    if left.count != lineAssertReferences.count {
        let correlation = left.count > lineAssertReferences.count ? "less" : "greater"
        XCTFail("References(\(lineAssertReferences.count)) are \(correlation) than Events(\(left.count))", file: file, line: line)
    }
    for i in 0..<lineAssertReferences.count {
        let r = lineAssertReferences[i]
        if let l = left[safe: i] {
            XCTAssertEqual(l, r, file:r.file, line: r.line)
        } else {
            XCTAssertEqual(nil, r, file:r.file, line: r.line)
        }
    }
}
