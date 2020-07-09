//
//  Many.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 05.07.2020.
//

import Foundation

/// Parses zero or more times of given parser
public struct Many<Element>: Combinator {
	public typealias Result = [Element]

	private let combinator: AnyCombinator<Element>

	public init<C: Combinator>(_ combinator: C) where Element == C.Result {
		self.combinator = AnyCombinator(combinator)
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		let firstResult = try combinator.parse(input)
		switch firstResult {
			case let .success(stream1, error1, result1):
				var _stream = stream1
				var _error = error1
				var _result = [result1]
				while true {
					let output = try combinator.parse(_stream)
					switch output {
						case let .success(stream, error, result):
							_stream = stream
							_error = .merge(_error, error)
							_result.append(result)
						case let .failure(error):
							return .success(stream: _stream, error: .merge(_error, error), result: _result)
					}
				}
			case let .failure(error):
				return .success(
					stream: ParseInput(stream: input.stream[...], position: input.position),
					error: error,
					result: []
				)
		}
	}
}
