//
//  Implication.swift
//  BooleanExpression
//
//  Created by Artem Bobrov on 11.07.2020.
//

import Foundation


precedencegroup ImplicationPrecedence {
	associativity: right
	higherThan: TernaryPrecedence
	lowerThan: LogicalDisjunctionPrecedence
}


infix operator -->: ImplicationPrecedence

func -->(lhs: Bool, rhs: @autoclosure () throws -> Bool) rethrows -> Bool {
	switch (lhs, try rhs()) {
		case (true, false):
			return false
		default:
			return true
	}
}
