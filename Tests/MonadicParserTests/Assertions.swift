//
//  Assertions.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

import XCTest
import Foundation
@testable import MonadicParser

#if swift(>=5.3)

internal func XCTAssertSuccessResult<Stream: StringProtocol, Result>(
	_ expression: @autoclosure () throws -> ParseResult<Stream, Result>,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #filePath,
	line: UInt = #line) {
	let value = try? expression()
	XCTAssertNotNil(value, "No error should be thrown")

	switch value! {
		case .success:
			break
		case .failure:
			XCTFail("Unexpected failure", file: file, line: line)
	}
}

internal func XCTAssertFailureResult<Stream: StringProtocol, Result>(
	_ expression: @autoclosure () throws -> ParseResult<Stream, Result>,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #filePath,
	line: UInt = #line) {
	let value = try? expression()
	XCTAssertNotNil(value, "No error should be thrown")

	switch value! {
		case .success:
			XCTFail("Unexpected success", file: file, line: line)
		case .failure:
			break
	}
}

internal func XCTAssertFailureResult<Stream: StringProtocol, Result>(
	_ expression: @autoclosure () throws -> ParseResult<Stream, Result>,
	expected: ParseError,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #filePath,
	line: UInt = #line) {
	let value = try? expression()
	XCTAssertNotNil(value, "No error should be thrown")

	switch value! {
		case .success:
			XCTFail("Unexpected success", file: file, line: line)
		case let .failure(error):
			XCTAssertEqual(error, expected)
	}
}

internal func XCTAssertSuccessResult<Stream: StringProtocol, Result: Equatable>(
	_ expression: @autoclosure () throws -> ParseResult<Stream, Result>,
	expected: Result,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #filePath,
	line: UInt = #line) {
	let value = try? expression()
	XCTAssertNotNil(value, "No error should be thrown", file: file, line: line)

	switch value! {
		case let .success(_, _, result):
			XCTAssertEqual(expected, result, file: file, line: line)
		case .failure:
			XCTFail("Unexpected failure", file: file, line: line)
	}
}


internal func XCTAssertSuccessResult<Stream: StringProtocol, Result: Equatable>(
	_ expression: @autoclosure () throws -> ParseResult<Stream, Result>,
	expected: (ParseInput<Stream>, Result),
	_ message: @autoclosure () -> String = "",
	file: StaticString = #filePath,
	line: UInt = #line) {
	let value = try? expression()
	XCTAssertNotNil(value, "No error should be thrown", file: file, line: line)

	switch value! {
		case let .success(stream, _, result):

			XCTAssertEqual(expected.0, stream, file: file, line: line)
			XCTAssertEqual(expected.1, result, file: file, line: line)
		case .failure:
			XCTFail("Unexpected failure", file: file, line: line)
	}
}
#else

internal func XCTAssertSuccessResult<Stream: StringProtocol, Result>(
	_ expression: @autoclosure () throws -> ParseResult<Stream, Result>,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file,
	line: UInt = #line) {
	let value = try? expression()
	XCTAssertNotNil(value, "No error should be thrown")

	switch value! {
		case .success:
			break
		case .failure:
			XCTFail("Unexpected failure", file: file, line: line)
	}
}

internal func XCTAssertFailureResult<Stream: StringProtocol, Result>(
	_ expression: @autoclosure () throws -> ParseResult<Stream, Result>,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file,
	line: UInt = #line) {
	let value = try? expression()
	XCTAssertNotNil(value, "No error should be thrown")

	switch value! {
		case .success:
			XCTFail("Unexpected success", file: file, line: line)
		case .failure:
			break
	}
}

internal func XCTAssertFailureResult<Stream: StringProtocol, Result>(
	_ expression: @autoclosure () throws -> ParseResult<Stream, Result>,
	expected: ParseError,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file,
	line: UInt = #line) {
	let value = try? expression()
	XCTAssertNotNil(value, "No error should be thrown")

	switch value! {
		case .success:
			XCTFail("Unexpected success", file: file, line: line)
		case let .failure(error):
			XCTAssertEqual(error, expected)
	}
}

internal func XCTAssertSuccessResult<Stream: StringProtocol, Result: Equatable>(
	_ expression: @autoclosure () throws -> ParseResult<Stream, Result>,
	expected: Result,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file,
	line: UInt = #line) {
	let value = try? expression()
	XCTAssertNotNil(value, "No error should be thrown", file: file, line: line)

	switch value! {
		case let .success(_, _, result):
			XCTAssertEqual(expected, result, file: file, line: line)
		case .failure:
			XCTFail("Unexpected failure", file: file, line: line)
	}
}


internal func XCTAssertSuccessResult<Stream: StringProtocol, Result: Equatable>(
	_ expression: @autoclosure () throws -> ParseResult<Stream, Result>,
	expected: (ParseInput<Stream>, Result),
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file,
	line: UInt = #line) {
	let value = try? expression()
	XCTAssertNotNil(value, "No error should be thrown", file: file, line: line)

	switch value! {
		case let .success(stream, _, result):

			XCTAssertEqual(expected.0, stream, file: file, line: line)
			XCTAssertEqual(expected.1, result, file: file, line: line)
		case .failure:
			XCTFail("Unexpected failure", file: file, line: line)
	}
}


#endif
