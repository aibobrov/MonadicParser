//
//  Parser.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 07.07.2020.
//

import Foundation

/// Protocol for complex parser based on simple `Combinator` primitives
public protocol Parser: Combinator where Result == ParserType.Result {
	associatedtype ParserType: Combinator

	var parser: ParserType { get }
}

public extension Parser {
	@inlinable
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		return try parser.parse(input)
	}
}
