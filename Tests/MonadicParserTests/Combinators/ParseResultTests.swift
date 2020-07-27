//
//  ParseResultTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 09.07.2020.
//

import XCTest
@testable import MonadicParser

class ParseResultTests: XCTestCase {
	func testFunctor() {
		let input = ParseInput(stream: "abcd", position: .initial)
		let result = ParseResult.success(stream: input , error: nil, result: -10)
		let newResult = result.map { String(abs($0)) }
		XCTAssertSuccessResult(newResult, expected: "10")
	}

	func testMonad1() {
		let input = ParseInput(stream: "abcd", position: .initial)
		let result = ParseResult.success(stream: input , error: nil, result: -10)
		let newResult: ParseResult<String, Int> = result.flatMap { _ in .failure(error: .undefined()) }
		XCTAssertFailureResult(newResult)
	}


	func testMonad2() {
		let input = ParseInput(stream: "abcd", position: .initial)
		let result = ParseResult.success(stream: input , error: nil, result: -100)
		let newResult: ParseResult<String, String> = result.flatMap {
			.success(stream: input, error: nil, result: String(abs($0)))

		}
		XCTAssertSuccessResult(newResult, expected: "100")
	}
}
