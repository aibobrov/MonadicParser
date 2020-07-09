
//
//  SeparatedBy1Tests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

@testable import MonadicParser
import XCTest

class SeparatedBy1Tests: XCTestCase {
	func testSuccess() {
		let term = Standart.natural
		let spaces = Many(Symbol(" "))
		let op = Some(Choice(Symbol("+"), Symbol("-"), Symbol("*"), Symbol("/")))
		let separator = Between(leading: spaces, trailing: spaces, op).map { String($0) }
		let parser = SeparatedBy1(term, separator)
		let result = try! parser("1231 + 23123 * 22131 - 82394 +   234 / 3")
		XCTAssertSuccessResult(
			result,
			expected: SeparatedBy1.Separated(
				terms: [1231, 23123, 22131, 82394, 234, 3],
				separators: ["+", "*", "-", "+", "/"]
			)
		)
	}

	func testSuccessWithRest1() {
		let term = Standart.natural
		let spaces = Many(Symbol(" "))
		let op = Some(Choice(Symbol("+"), Symbol("-"), Symbol("*"), Symbol("/")))
		let separator = Between(leading: spaces, trailing: spaces, op).map { String($0) }
		let parser = SeparatedBy1(term, separator)
		let result = try! parser("1231 + 23123 * 22131 - 82394 +   234 / ")
		XCTAssertSuccessResult(
			result,
			expected: (
				ParseInput(stream: Substring(" / "), position: Position(line: 0, column: 36)),
				SeparatedBy1.Separated(
					terms: [1231, 23123, 22131, 82394, 234],
					separators: ["+", "*", "-", "+"]
				)
			)
		)
	}

	func testFaulure2() {
		let term = Standart.natural
		let spaces = Many(Symbol(" "))
		let op = Some(Choice(Symbol("+"), Symbol("-"), Symbol("*"), Symbol("/")))
		let separator = Between(leading: spaces, trailing: spaces, op).map { String($0) }
		let parser = SeparatedBy1(term, separator)
		let result = try! parser("-1231 + 23123")
		XCTAssertFailureResult(result)
	}
}
