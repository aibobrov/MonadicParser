//
//  Combinator+Alternative.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 01.07.2020.
//

import Foundation

public struct Alternative<Result>: Combinator {
	private let first: AnyCombinator<Result>
	private let second: AnyCombinator<Result>

	public init<First: Combinator, Second: Combinator>(
		first: First,
		second: Second
	) where Result == First.Result, First.Result == Second.Result {
		self.first = AnyCombinator(first)
		self.second = AnyCombinator(second)
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		let firstResult = try first.parse(input)
		switch firstResult {
			case let .failure(error1):
				let secondResult = try second.parse(input)
				switch secondResult {
					case let .failure(error2):
						return .failure(error: .merge(error1, error2))
					default:
						return secondResult
				}
			case .success:
				return firstResult
		}
	}
}

public extension Combinator {
	/// Alternative idiom for `Combinator`
	/// Parses `self` or `other`
	@inlinable
	func or<C: Combinator>(_ other: C) -> Alternative<Self.Result> where Self.Result == C.Result {
		return Alternative(first: self, second: other)
	}
}

infix operator <|>: LogicalDisjunctionPrecedence

/// Alternative operator for `Combinator`
/// Parses `self` or `other`
public func <|> <P: Combinator, C: Combinator>(_ lhs: P, _ rhs: C) -> Alternative<P.Result> where P.Result == C.Result {
	return lhs.or(rhs)
}
