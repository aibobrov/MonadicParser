//
//  Combinator+Applicative.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 01.07.2020.
//

import Foundation

public extension Combinator {
	/// Alternative idiom for `Combinator`
	@inline(__always)
	func apply<C: Combinator, T>(_ rhs: C) -> Monad<Self, Functor<C, T>> where Result == (C.Result) -> T {
		return flatMap { rhs.map($0) }
	}
}

infix operator <*>: LogicalConjunctionPrecedence
infix operator *>: LogicalConjunctionPrecedence
infix operator <*: LogicalConjunctionPrecedence

/// Alternative operator for `Combinator`
@inlinable
public func <*> <P: Combinator, C: Combinator, T>(
	_ lhs: P, _ rhs: C
) -> Monad<P, Functor<C, T>> where P.Result == (C.Result) -> T {
	return lhs.apply(rhs)
}

/// Alternative operator for `Combinator` but ignores the left value
@inlinable
public func *> <P: Combinator, C: Combinator>(_ lhs: P, _ rhs: C)
-> Monad<Functor<P, (C.Result) -> C.Result>, Functor<C, C.Result>> {
	return { $0 } <^ lhs <*> rhs
}

/// Alternative operator for `Combinator` but ignores the right value
@inlinable
public func <* <P: Combinator, C: Combinator>(
	_ lhs: P, _ rhs: C
) -> Monad<Functor<P, (C.Result) -> P.Result>, Functor<C, P.Result>> {
	return liftA2(lhs, rhs) { x, _ in x }
}

/// Applies a `transform` function on results of 2 given combinators. Haskell liftA2 analog.
@inlinable
public func liftA2<P: Combinator, C: Combinator, R>(
	_ combinator1: P, _ combinator2: C, _ transform: @escaping (P.Result, C.Result) -> R
) -> Monad<Functor<P, (C.Result) -> R>, Functor<C, R>> {
	let f = curry(transform)
	return combinator1.map(f) <*> combinator2
}
