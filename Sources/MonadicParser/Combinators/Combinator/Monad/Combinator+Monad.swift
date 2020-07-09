//
//  Combinator+Monad.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 30.06.2020.
//

import Foundation

public struct Monad<InnerParser: Combinator, OuterParser: Combinator>: Combinator {
	public typealias Result = OuterParser.Result
	public typealias Transform = (InnerParser.Result) throws -> OuterParser

	private let transform: Transform

	private let inner: InnerParser

	public init(inner: InnerParser, transform: @escaping Transform) {
		self.inner = inner
		self.transform = transform
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		switch try inner.parse(input) {
			case let .success(stream, error1, result):
				switch try transform(result).parse(stream) {
					case let .success(stream1, error2, result):
						return .success(stream: stream1, error: .merge(error1, error2), result: result)
					case let .failure(error2):
						return .failure(error: ParseError.merge(error1, error2) ?? error2)
				}

			case let .failure(error):
				return .failure(error: error)
		}
	}
}

public extension Combinator {
	/// Monad idiom for `Combinator`
	@inline(__always)
	func flatMap<C: Combinator>(_ transform: @escaping (Result) throws -> C) -> Monad<Self, C> {
		return Monad(inner: self, transform: transform)
	}
}

precedencegroup MonadPrecedence {
	associativity: left
	higherThan: AssignmentPrecedence
	lowerThan: TernaryPrecedence
}

infix operator >>=: MonadPrecedence
infix operator >>: MonadPrecedence

/// Monad operator for `Combinator`
@inlinable
public func >>= <P: Combinator, C: Combinator>(
	_ parser: P, _ transform: @escaping (P.Result) throws -> C
) -> Monad<P, C> {
	return parser.flatMap(transform)
}

/// Monad operator for `Combinator` but using the given right parser
@inlinable
public func >> <P: Combinator, C: Combinator>(_ parser: P, _ combinator: C) -> Monad<P, C> {
	return parser.flatMap { _ in combinator }
}
