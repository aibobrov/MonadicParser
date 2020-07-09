//
//  Between.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 05.07.2020.
//

import Foundation

/// Parses `leading`, followed by `content` and `trailing`
public struct Between<Leading: Combinator, Trailing: Combinator, C: Combinator>: Parser {
	public typealias ParserType = Monad<Functor<Monad<Functor<Leading, (C.Result) -> C.Result>, Functor<C, C.Result>>, (Trailing.Result) -> Monad<Functor<Leading, (C.Result) -> C.Result>, Functor<C, C.Result>>.Result>, Functor<Trailing, Monad<Functor<Leading, (C.Result) -> C.Result>, Functor<C, C.Result>>.Result>> // swiftlint:disable:this line_length

	public typealias Result = C.Result

	public let parser: ParserType

	public init(leading: Leading, trailing: Trailing, _ content: C) {
		parser = leading *> content <* trailing
	}
}

@available(OSX 10.15.0, *)
@inline(__always)
public func between<Leading: Combinator, Trailing: Combinator, C: Combinator>(
	leading: Leading, trailing: Trailing, _ content: C
) -> some Combinator {
	return Between(leading: leading, trailing: trailing, content)
}
