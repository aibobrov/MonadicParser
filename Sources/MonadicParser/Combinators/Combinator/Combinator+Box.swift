//
//  Combinator+Concatenate.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 07.07.2020.
//

import Foundation

precedencegroup ConcatPrecedence {
	associativity: left
	higherThan: TernaryPrecedence
	lowerThan: LogicalDisjunctionPrecedence
}

infix operator ++: ConcatPrecedence

/// Box concatination helpers
@inline(__always)
public func boxed<L: Boxed, R: Boxed>(
	_ lhs: L, _ rhs: R
) -> [L.BoxType] where L.BoxType == R.BoxType {
	return [lhs.boxed, rhs.boxed]
}

@inline(__always)
public func boxed<L: Boxed, R: Boxed>(_ lhs: [L], _ rhs: R) -> [L] where L == R.BoxType {
	return lhs + [rhs.boxed]
}

@inline(__always)
public func boxed<L: Boxed, R: Boxed>(_ lhs: L, _ rhs: [R]) -> [L.BoxType] where L.BoxType == R {
	return [lhs.boxed] + rhs
}

@inline(__always)
public func boxed<L>(_ lhs: [L], _ rhs: [L]) -> [L] {
	return lhs + rhs
}
/// Box concatination operator
@inline(__always)
public func ++ <L: Boxed, R: Boxed>(
	_ lhs: L, _ rhs: R
) -> [L.BoxType] where L.BoxType == R.BoxType {
	return boxed(lhs, rhs)
}

@inline(__always)
public func ++ <L: Boxed, R: Boxed>(_ lhs: [L], _ rhs: R) -> [L] where L == R.BoxType {
	return boxed(lhs, rhs)
}

@inline(__always)
public func ++ <L: Boxed, R: Boxed>(_ lhs: L, _ rhs: [R]) -> [L.BoxType] where L.BoxType == R {
	return boxed(lhs, rhs)
}

@inline(__always)
public func ++ <L>(_ lhs: [L], _ rhs: [L]) -> [L] {
	return boxed(lhs, rhs)
}
