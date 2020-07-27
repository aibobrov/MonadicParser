//
//  Combinator.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 28.06.2020.
//

import Foundation

/// Main parse combinator protocol
public protocol Combinator: Boxed where BoxType == AnyCombinator<Result> {
	associatedtype Result

	/// Parses the given input
	@inlinable
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result>
}

public extension Combinator {
	@inline(__always)
	func callAsFunction<Stream: StringProtocol>(
		_ input: ParseInput<Stream>
	) throws -> ParseResult<Stream.SubSequence, Result> {
		return try parse(input)
	}

	@inline(__always)
	func callAsFunction<Stream: StringProtocol>(_ stream: Stream) throws -> ParseResult<Stream.SubSequence, Result> {
		let input = ParseInput(stream: stream, position: .initial)
		return try callAsFunction(input)
	}

	var boxed: AnyCombinator<Result> {
		return AnyCombinator(self)
	}
}
