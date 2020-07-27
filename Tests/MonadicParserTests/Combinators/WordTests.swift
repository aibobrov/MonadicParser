//
//  WordTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 09.07.2020.
//

import XCTest
@testable import MonadicParser
class WordTests: XCTestCase {
	func testSuccess() {
		let word = Word("hello")
		let result = try! word("hello word")
		XCTAssertSuccessResult(result)
	}

	func testSuccess2() {
		let word = Word(" he llo ")
		let result = try! word(" he llo word")
		XCTAssertSuccessResult(result)
	}

	func testFailure() {
		let word = Word("hell ")
		let result = try! word("hello word")
		XCTAssertFailureResult(result)
	}

	func testFailure2() {
		let word = Word("hello")
		let result = try! word("he")
		XCTAssertFailureResult(result)
	}

	func testFailure3() {
		let word = Word("ho")
		let result = try! word("he")
		XCTAssertFailureResult(result)
	}
}
