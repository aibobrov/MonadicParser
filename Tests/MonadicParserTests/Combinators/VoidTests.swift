
//
//  VoidTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

@testable import MonadicParser
import XCTest

class VoidTests: XCTestCase {
	func testSuccess() {
		let parser = void(Element())
		let result = try! parser("xxx")
		XCTAssertSuccessResult(result)
	}

	func testFailure() {
		let parser = void(Element())
		let result = try! parser("")
		XCTAssertFailureResult(result)
	}
}
