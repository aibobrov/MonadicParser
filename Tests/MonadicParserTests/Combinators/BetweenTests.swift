
//
//  BetweenTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

@testable import MonadicParser
import XCTest

class BetweenTests: XCTestCase {
    func testSuccess() throws {
        let parser = Between(leading: Symbol("{"), trailing: Symbol("}"), Many(Symbol("x")))
        let result = try! parser.boxed("{xxxxxxx}").map { String($0) }
		XCTAssertSuccessResult(result, expected: "xxxxxxx")
    }

    func testSuccessNotComplete() throws {
        let parser = Between(leading: Symbol("{"), trailing: Symbol("}"), Many(Symbol("x")))
        let result: ParseResult<Substring, String> = try! parser.boxed("{xxxxx}xxnn").map { String($0) }

        let extectedInput: ParseInput<Substring> = ParseInput(stream: "xxnn", position: Position(line: 0, column: 7))
        XCTAssertSuccessResult(result, expected: (extectedInput, "xxxxx"))
    }

    func testFailure() throws {
        let parser = Between(leading: Symbol("{"), trailing: Symbol("}"), Many(Symbol("x")))
        let result = try! parser.boxed("{xxxxxxxnn").map { String($0) }
        XCTAssertFailureResult(result)
    }
}
