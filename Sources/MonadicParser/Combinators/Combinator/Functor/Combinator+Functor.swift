//
//  Combinator+Functor.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 30.06.2020.
//

import Foundation

public struct Functor<InnerParser: Combinator, Result>: Combinator {
	public typealias Transform = (InnerParser.Result) throws -> Result

	private let transform: Transform

	private let inner: InnerParser

	public init(inner: InnerParser, transform: @escaping Transform) {
		self.inner = inner
		self.transform = transform
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		return try inner.parse(input).map(transform)
	}
}

public extension Combinator {
	/// Functor idiom for `Combinator`
	/// Transforms the result of the combinator unsing given function
	@inline(__always)
	func map<U>(_ transform: @escaping (Result) throws -> U) -> Functor<Self, U> {
		return Functor(inner: self, transform: transform)
	}
}

infix operator <^>: LogicalConjunctionPrecedence
infix operator ^>: LogicalConjunctionPrecedence
infix operator <^: LogicalConjunctionPrecedence

/// Functor operator for `Combinator`
/// Transforms the result of the combinator unsing given function
public func <^> <C: Combinator, U>(_ transform: @escaping (C.Result) -> U, _ combinator: C) -> Functor<C, U> {
	return combinator.map(transform)
}

/// Functor idiom for `Combinator`
/// Transforms the result of the combinator unsing given function but using the left given value
public func <^ <C: Combinator, U>(_ value: U, _ combinator: C) -> Functor<C, U> {
	return combinator.map { _ in value }
}

/// Functor idiom for `Combinator`
/// Transforms the result of the combinator unsing given function but using the right given value
public func ^> <C: Combinator, U>(_ combinator: C, _ value: U) -> Functor<C, U> {
	return combinator.map { _ in value }
}
