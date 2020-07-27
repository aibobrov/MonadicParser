//
//  ParseResult.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 28.06.2020.
//

import Foundation

/// Parsing result containing errors, parse result and processed stream or parse error
public enum ParseResult<Stream: StringProtocol, Result> {
	case success(stream: ParseInput<Stream>, error: ParseError?, result: Result)

	case failure(error: ParseError)
}

public extension ParseResult {
	/// Functor idiom for `ParseResult`
	func map<U>(_ transform: (Result) throws -> U) rethrows -> ParseResult<Stream, U> {
		switch self {
			case let .success(stream, error, result):
				return try .success(stream: stream, error: error, result: transform(result))
			case let .failure(error):
				return .failure(error: error)
		}
	}

	/// Monad idiom for `ParseResult`
	func flatMap<U>(_ transform: (Result) throws -> ParseResult<Stream, U>) rethrows -> ParseResult<Stream, U> {
		switch self {
			case let .success(_, _, result):
				return try transform(result)
			case let .failure(error):
				return .failure(error: error)
		}
	}
}
