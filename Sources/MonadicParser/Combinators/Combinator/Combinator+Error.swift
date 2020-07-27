//
//  Combinator+Error.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 01.07.2020.
//

import Foundation

public struct CombinatorError<Inner: Combinator>: Combinator {
	public typealias Result = Inner.Result

	private let inner: Inner

	private let error: ParseError

	public init(inner: Inner, error: ParseError) {
		self.inner = inner
		self.error = error
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		let result = try inner.parse(input)
		switch result {
			case .failure:
				return .failure(error: error.with(input.position))
			default:
				return result
		}
	}
}

public extension Combinator {
	/// Replaces the error this the given one
	@inline(__always)
	func replace(with error: ParseError) -> CombinatorError<Self> {
		return CombinatorError(inner: self, error: error)
	}
}

infix operator <?>: MonadPrecedence

public func <?> <C: Combinator>(_ parser: C, _ error: ParseError) -> CombinatorError<C> {
	return parser.replace(with: error)
}
