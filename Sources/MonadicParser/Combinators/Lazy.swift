//
//  Lazy.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 08.07.2020.
//

import Foundation

public final class Lazy<C: Combinator>: Combinator {
	public typealias Result = C.Result

	private var factory: () -> C

	public init(_ factory: @autoclosure @escaping () -> C) {
		self.factory = factory
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		factory = {
			let combinator = factory()
			return { combinator }
		}()
		return try factory().parse(input)
	}
}
