//
//  Position.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 28.06.2020.
//

import Foundation

/// Struct representing position in a given stream
public struct Position: Hashable {
	public static let initial = Position(line: 0, column: 0)

	public let line: UInt

	public let column: UInt

	@inlinable
	public init(line: UInt, column: UInt) {
		self.line = line
		self.column = column
	}
}

extension Position: Comparable {
	public static func < (lhs: Position, rhs: Position) -> Bool {
		return lhs.line < rhs.line || lhs.line == rhs.line && lhs.column < rhs.column
	}
}

private extension Position {
	func incrementedLine(by value: UInt = 1) -> Position {
		Position(line: line + value, column: 0)
	}

	func incrementedColumn(by value: UInt = 1) -> Position {
		Position(line: line, column: column + value)
	}
}

internal extension Position {
	/// Processing one character
	func processed(_ character: Character) -> Position {
		switch character {
			case "\n": return incrementedLine()
			case "\t": return incrementedColumn(by: column + 8 - ((column - 1) % 8))
			default: return incrementedColumn()
		}
	}
}
