
//
//  SymbolTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

@testable import MonadicParser
import XCTest

class SymbolTests: XCTestCase {
	func testSuccess() {
		let parser = Symbol("x")
		let result = try! parser("xxx")
		XCTAssertSuccessResult(result, expected: "x")
	}

	func testFailure1() {
		let parser = Symbol("a")
		let result = try! parser("")
		XCTAssertFailureResult(result)
	}

	func testFailure2() {
		let parser = Symbol("b")
		let result = try! parser("c")
		XCTAssertFailureResult(result)
	}
}
