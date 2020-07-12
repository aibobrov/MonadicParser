//
//  ParseError.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 30.06.2020.
//

import Foundation

/// Parsing error
public struct ParseError: Error {
	public let position: Position

	public let error: Error

	@inlinable
	public init(position: Position, error: Error) {
		self.position = position
		self.error = error
	}
}

public extension ParseError {
	func with(_ position: Position) -> Self {
		return ParseError(position: position, error: error)
	}
}

extension ParseError: Equatable {
	public static func == (lhs: ParseError, rhs: ParseError) -> Bool {
		return lhs.position == rhs.position
	}
}
