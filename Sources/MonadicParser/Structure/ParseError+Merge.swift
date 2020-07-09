//
//  ParseError+Merge.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 01.07.2020.
//

import Foundation

public extension ParseError {
	/// Combining the 2 error using "Keep the latest error" strategy
	static func merge(_ lhs: ParseError?, _ rhs: ParseError?) -> ParseError? {
		switch (lhs, rhs) {
			case (nil, nil):
				return nil
			case let (lhs?, nil):
				return lhs
			case let (nil, rhs?):
				return rhs
			case let (lhs?, rhs?):
				return mergeNonNil(lhs, rhs)
		}
	}

	static func merge(_ lhs: ParseError, _ rhs: ParseError) -> ParseError {
		return mergeNonNil(lhs, rhs)
	}

	/// Strategy: Keep the latest error
	private static func mergeNonNil(_ lhs: ParseError, _ rhs: ParseError) -> ParseError {
		if lhs.position == rhs.position {
			return ParseError(position: lhs.position, errors: lhs.errors + rhs.errors)
		} else if lhs.position < rhs.position {
			return rhs
		} else { // lhs.position > rhs.position
			return lhs
		}
	}
}
