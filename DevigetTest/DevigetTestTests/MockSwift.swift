//
//  MockSwift.swift
//  DevigetTestTests
//
//  Created by Rodrigo Camparo on 03/02/2021.
//

import XCTest
import Foundation

protocol Mock {
    func totalNumberOfCalls() -> Int
}

struct MockCounter {
    var timesCalled: Int

    init() {
        timesCalled = 0
    }

    mutating func wasCalled() {
        timesCalled += 1
    }
}

extension Mock {
    func totalNumberOfCalls() -> Int {
        var numberOfTimes = 0
        var mirror: Mirror? = Mirror(reflecting: self)
        while let mirrored = mirror {
            print("evaluating calls in: \(mirrored.subjectType)")
            for (name, value) in mirrored.children {
                guard let counter = value as? MockCounter, counter.timesCalled > 0, let name = name else { continue }
                numberOfTimes += counter.timesCalled
                print("\(name) was called: \(counter.timesCalled)")
            }
            mirror = mirrored.superclassMirror
        }
        return numberOfTimes
    }
}

class MockSwift {
    static func verify(_ timesCalled: @escaping () -> MockCounter, wasCalledTimes timesExpected: Int = 1) {
        XCTAssert(timesCalled().timesCalled == timesExpected)
    }

    static func verify<M: Mock>(_ mock: @escaping () -> M, wasCalledTimes timesExpected: Int = 1) {
        assertNumberOfTimesCalled(mock, wasCalledTimes: timesExpected)
    }

    static func verifyZeroInteractions(_ timesCalled: @escaping () -> MockCounter) {
        XCTAssert(timesCalled().timesCalled == 0)
    }

    static func verifyZeroInteractions<M: Mock>(_ mock: @escaping () -> M) {
        assertNumberOfTimesCalled(mock, wasCalledTimes: 0)
    }

    private static func assertNumberOfTimesCalled<M: Mock>(_ mock: @escaping () -> M, wasCalledTimes timesExpected: Int = 1) {
        XCTAssert(mock().totalNumberOfCalls() == timesExpected)
    }
}

