
//
//  PureTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

@testable import MonadicParser
import XCTest

class PureTests: XCTestCase {
	func testSuccess() {
		let parser = Pure("x")
		let result = try! parser("")
		XCTAssertSuccessResult(result, expected: "x")
	}
}
