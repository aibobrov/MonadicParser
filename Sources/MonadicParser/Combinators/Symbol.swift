//
//  Symbol.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 30.06.2020.
//

import Foundation

/// Parses a the symbol. Succedes if `symbol == character`
public struct Symbol: Parser {
	public typealias ParserType = Satisfy
	public typealias Result = Satisfy.Result

	public let parser: ParserType

	public init(_ character: Character) {
		parser = Satisfy {
			$0 == character
		}
	}
}

@available(OSX 10.15.0, *)
@inline(__always)
func symbol(_ character: Character) -> some Combinator {
	return Symbol(character)
}
