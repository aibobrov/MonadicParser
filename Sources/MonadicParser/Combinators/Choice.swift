//
//  Choice.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 02.07.2020.
//

import Foundation

/// Tries to apply the parsers in the collection `combinators` in order, until one of them succeeds.
/// Returns the value of the succeeding parser.
public struct Choice<P: Combinator>: Parser {
	public typealias ParserType = Alternative<Choice<P>.Result>
	public typealias Result = P.Result

	public let parser: ParserType

	public init<C: Collection>(_ combinators: C) where C.Element == P {
		precondition(!combinators.isEmpty, "Collection must contain at least one combinator")
		let first = combinators.first! // collection shouldn't be empty
		let initial = Alternative<Result>(first: first, second: Empty())
		parser = combinators.reduce(initial, <|>)
	}

	public init(_ combinators: P...) {
		self.init(combinators)
	}
}
