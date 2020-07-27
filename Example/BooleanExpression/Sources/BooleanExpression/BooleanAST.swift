//
//  BooleanAST.swift
//  BooleanExpression
//
//  Created by Artem Bobrov on 09.07.2020.
//

import Foundation

indirect enum BooleanAST {
    enum Operator {
        case conjunction
        case disjunction
        case negation
        case implication
    }

    case conjunction(_ lhs: BooleanAST, _ rhs: BooleanAST)
    case disjunction(_ lhs: BooleanAST, _ rhs: BooleanAST)
    case negation(_ expr: BooleanAST)
    case implication(_ lhs: BooleanAST, _ rhs: BooleanAST)
    case identifier(_ name: String)
    case constant(_ boolean: Bool)


	func identifiers() -> Set<String> {
	 switch self {
		case let .conjunction(lhs, rhs):
			return lhs.identifiers().union(rhs.identifiers())
		case let .disjunction(lhs, rhs):
			return lhs.identifiers().union(rhs.identifiers())
		case let .negation(expr):
			return expr.identifiers()
		case let .implication(lhs, rhs):
			return lhs.identifiers().union(rhs.identifiers())
		case let .identifier(name):
			return [name]
		case .constant:
			return []
	}
 }
}

extension BooleanAST: CustomStringConvertible {
	private static func buildString(_ expression: BooleanAST, level: Int = 0) -> String {
		var string = ""
		if level > 0 {
			string += String(repeating: "| ", count: level - 1) + "|_"
		}
		switch expression {
			case let .conjunction(lhs, rhs):
				string += "&&\n"
				string += buildString(lhs, level: level + 1)
				string += buildString(rhs, level: level + 1)
			case let .disjunction(lhs, rhs):
				string += "||\n"
				string += buildString(lhs, level: level + 1)
				string += buildString(rhs, level: level + 1)
			case let .negation(expr):
				string += "!\n"
				string += buildString(expr, level: level + 1)
			case let .identifier(name):
				string += name + "\n"
			case let .constant(flag):
				string += String(flag) + "\n"
			case let .implication(lhs, rhs):
				string += "->\n"
				string += buildString(lhs, level: level + 1)
				string += buildString(rhs, level: level + 1)
		}
		return string
	}

	var description: String { Self.buildString(self) }
}



extension BooleanAST {
	typealias Environment = [String: Bool]
	func execute(using map: Environment) -> Bool? {
		switch self {
			case let .conjunction(lhs, rhs):
				return process(
					lhs.execute(using: map),
					rhs.execute(using: map),
					{ $0 && $1 }
				)
			case let .disjunction(lhs, rhs):
				return process(
					lhs.execute(using: map),
					rhs.execute(using: map),
					{ $0 || $1 }
				)
			case let .negation(expr):
				return expr.execute(using: map).map { !$0 }
			case let .implication(lhs, rhs):
				return process(
					lhs.execute(using: map),
					rhs.execute(using: map),
					{ $0 --> $1 }
				)
			case let .identifier(name):
				return map[name]
			case let .constant(flag):
				return flag
		}
	}
}


private func process(_ lhs: Bool?, _ rhs: Bool?, _ function: (Bool, Bool) -> Bool) -> Bool? {
	guard let left = lhs,
		  let right = rhs else {
		return nil
	}
	return function(left, right)
}
