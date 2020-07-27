//
//  Void.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 07.07.2020.
//

import Foundation

/// Discards the return type
@inlinable
public func void<C: Combinator>(_ combinator: C) -> Functor<C, Void> {
	return combinator.map { _ in () }
}
