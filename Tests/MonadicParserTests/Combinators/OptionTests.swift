
//
//  OptionTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

@testable import MonadicParser
import XCTest

class OptionTests: XCTestCase {
	func testSuccess1() {
		let parser = Option("x", Element())
		let result = try! parser("")
		XCTAssertSuccessResult(result, expected: "x")
	}

	func testSuccess2() {
		let parser = Option("x", Element())
		let result = try! parser("c")
		XCTAssertSuccessResult(result, expected: "c")
	}

	func testSuccess3() {
		let parser = Element() ?? "x"
		let result = try! parser("")
		XCTAssertSuccessResult(result, expected: "x")
	}
}
