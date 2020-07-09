//
//  Standart.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 02.07.2020.
//

import Foundation

public enum Standart {}

public extension Standart {
	/// Digit parser
	static let digit = Satisfy { $0.isWholeNumber }.map { UInt($0.wholeNumberValue!) }

	/// Natural number parser
	static let natural = Some(digit).map { $0.reduce(0) { $1 + 10 * $0 } }

	/// Letter parser
	static let letter = Satisfy { $0.isLetter }

	/// Word parser
	static let word = Many(letter).map { String($0) }
}
