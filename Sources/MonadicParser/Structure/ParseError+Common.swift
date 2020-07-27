//
//  ParseError+Common.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 01.07.2020.
//

import Foundation

public extension ParseError {
	/// Common error used by the library
	enum Common: Error, Equatable {
		case undefined
		case custom(_ description: String)
		case predicateFailure
		case keywordNotFound
	}

	/// Function-factory for `undefined` parsing error
	@inline(__always)
	static func undefined(on position: Position = .initial) -> ParseError {
		return ParseError(position: position, error: Common.undefined)
	}

	/// Function-factory for `predicateFailure` parsing error
	@inline(__always)
	static func predicateFailure(on position: Position = .initial) -> ParseError {
		return ParseError(position: position, error: Common.predicateFailure)
	}

	/// Function-factory for `custom` parsing error
	@inline(__always)
	static func custom(on position: Position = .initial, _ description: String) -> ParseError {
		return ParseError(position: position, error: Common.custom(description))
	}

	/// Function-factory for `keywordNotFound` parsing error
	@inline(__always)
	static func keywordNotFound(on position: Position = .initial) -> ParseError {
		return ParseError(position: position, error: Common.keywordNotFound)
	}
 }
