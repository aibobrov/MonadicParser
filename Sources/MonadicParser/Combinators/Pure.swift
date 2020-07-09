//
//  Pure.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 06.07.2020.
//

import Foundation

/// Successful parser with given value. Do not proceeds any element of the stream
public struct Pure<Result>: Combinator {
	public let value: Result

	public init(_ value: Result) {
		self.value = value
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		let stream = ParseInput(stream: input.stream[...], position: input.position)
		return .success(stream: stream, error: nil, result: value)
	}
}
