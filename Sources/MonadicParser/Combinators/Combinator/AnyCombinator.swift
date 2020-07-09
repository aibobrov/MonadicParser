//
//  AnyCombinator.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 04.07.2020.
//

import Foundation

private class AnyCombinatorBox<Result>: Combinator {
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		abstract()
	}
}

private final class CombinatorBox<C: Combinator>: AnyCombinatorBox<C.Result> {
	private let combinator: C

	fileprivate init(_ combinator: C) {
		self.combinator = combinator
	}

	@inlinable
	override
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		return try combinator.parse(input)
	}
}

/// Type-erasure idiom for protocol `Combinator`
public struct AnyCombinator<Result>: Combinator {
	private let box: AnyCombinatorBox<Result>

	public init<C: Combinator>(_ combinator: C) where Result == C.Result {
		box = CombinatorBox(combinator)
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		return try box.parse(input)
	}

	public var boxed: AnyCombinator<Result> { return self }
}
