//
//  Standard.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 02.07.2020.
//

import Foundation

public enum Standard {}

public extension Standard {
	/// Digit parser
	static let digit = Satisfy { $0.isDigit }.map { UInt($0.wholeNumberValue!) }

	/// Natural number parser
	static let natural = Some(digit).map { $0.reduce(0) { $1 + 10 * $0 } }

	/// Letter parser
	static let letter = Satisfy { $0.isLetter }

	/// Word parser
	static let word = Many(letter).map { String($0) }

	/// Alphabetical symbol parser
	static let alphabetical = Satisfy { $0.isAlpha }

	/// Identifier parser for regex: `[_a-zA-Z][_a-zA-Z0-9]*`
	static let identifier = curry { x, y in String([x] + y) } <^>
		(Symbol("_") <|> Self.alphabetical) <*>
		Many(Symbol("_") <|> Self.alphabetical <|> Satisfy { $0.isDigit })
}
