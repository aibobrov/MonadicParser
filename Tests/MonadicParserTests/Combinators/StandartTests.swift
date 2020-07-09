
//
//  StandartTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

@testable import MonadicParser
import XCTest

class StandartTests: XCTestCase {
	func testDigitSuccess() {
		let number = Standart.natural
		XCTAssertSuccessResult(try! number("112312"), expected: 112312)
		XCTAssertSuccessResult(try! number("023432"), expected: 23432)
	}


	func testDigitSuccess2() {
		func sum7(_ n1: UInt, _ n2: UInt, _ n3: UInt, _ n4: UInt, _ n5: UInt, _ n6: UInt, _ n7: UInt) -> UInt {
			return n1 + n2 + n3 + n4 + n5 + n6 + n7
		}
		let plus = Symbol("+")
		let number = Standart.natural
		let parser = curry(sum7) <^> number <*
			plus <*> number <*
			plus <*> number <*
			plus <*> number <*
			plus <*> number <*
			plus <*> number <*
			plus <*> number
		XCTAssertSuccessResult(try! parser("23+324+432+432+432+54+945"), expected: 2642)
	}

	func testDigitFailure() {
		let number = Standart.natural
		XCTAssertFailureResult(try! number("-112312"))
		XCTAssertFailureResult(try! number(""))
	}

	func testWordsSuccess1() {
		let word = Standart.word
		XCTAssertSuccessResult(try! word("hello world"), expected: "hello")
	}

	func testWordsSuccess2() {
		let spaces = Some(Symbol(" "))

		let words = SeparatedBy1(Standart.word, spaces).map { $0.terms }
		XCTAssertSuccessResult(try! words("hello world"), expected: ["hello", "world"])
	}
}
