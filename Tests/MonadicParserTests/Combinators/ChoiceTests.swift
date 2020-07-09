
//
//  ChoiceTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

@testable import MonadicParser
import XCTest

class ChoiceTests: XCTestCase {
    func testSuccess() {
        let choice = Some(Choice(Symbol("+"), Symbol("-"), Symbol("*"), Symbol("/"))).map { String($0) }
        let result = try! choice("-+/---+^")
        XCTAssertSuccessResult(result, expected: "-+/---+")
    }

	func testSuccessConcatination() {
		let satisfy = Satisfy { $0.isLetter }
		let boxed = Symbol("_").boxed
		let choice = Some(
				Choice(Symbol("+") ++ Symbol("-") ++ Symbol("*") ++ Symbol("/") ++ satisfy ++ boxed)
			)
			.map { String($0) }
		let result = try! choice("-+/---+^")
		XCTAssertSuccessResult(result, expected: "-+/---+")
	}

    func testFailure() {
        let choice = Choice(Symbol("+"), Symbol("-"), Symbol("*"), Symbol("/"))
        let result = try! choice("^")
        XCTAssertFailureResult(result)
    }
}
