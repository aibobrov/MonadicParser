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

	public let errors: [Error]

	@inlinable
	public init(position: Position, errors: [Error]) {
		self.position = position
		self.errors = errors
	}
}

public extension ParseError {
	func with(_ position: Position) -> Self {
		return ParseError(position: position, errors: errors)
	}
}

extension ParseError: Equatable {
	public static func == (lhs: ParseError, rhs: ParseError) -> Bool {
		return lhs.position == rhs.position && lhs.errors.count == rhs.errors.count
	}
}
