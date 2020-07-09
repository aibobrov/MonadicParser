
//
//  ElementTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

@testable import MonadicParser
import XCTest

class ElementTests: XCTestCase {
    func testSuccess() {
        let parser = curry { x, y in "\(x)\(y)" } <^> Element() <*> Element()

        let result = try! parser("abcd")
        XCTAssertSuccessResult(result, expected: "ab")
    }

    func testFailure1() {
        let parser = curry { x, y in "\(x)\(y)" } <^> Element() <*> Element()

        let result = try! parser("a")
        XCTAssertFailureResult(result)
    }

    func testFailure2() {
        let parser = Element()

        let result = try! parser("")
        XCTAssertFailureResult(result)
    }
}
