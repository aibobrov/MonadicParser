//
//  Some.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 05.07.2020.
//

import Foundation

/// Parses one or more times of given parser
public struct Some<Element>: Combinator {
	public typealias Result = [Element]

	private let combinator: AnyCombinator<Element>

	public init<C: Combinator>(_ combinator: C) where Element == C.Result {
		self.combinator = AnyCombinator(combinator)
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		let firstResult = try combinator.parse(input).map { [$0] }
		switch firstResult {
			case let .success(stream1, error1, result1):
				let many = Many(combinator)
				let manyResult = try many.parse(stream1)
				switch manyResult {
					case let .success(stream2, error2, result2):
						return .success(stream: stream2, error: .merge(error1, error2), result: result1 + result2)
					case let .failure(error2):
						return .success(stream: stream1, error: .merge(error1, error2), result: result1)
				}
			case .failure:
				return firstResult
		}
	}
}
