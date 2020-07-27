//
//  CombinatorErrorTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 08.07.2020.
//

@testable import MonadicParser
import XCTest

class CombinatorTests: XCTestCase {
	func testErrorSubstitute() {
		let error: ParseError = .custom("Empty stream")
		let parser = void(Element()) <?> error
		let result = try! parser("")

		XCTAssertFailureResult(result, expected: error)
	}
}
