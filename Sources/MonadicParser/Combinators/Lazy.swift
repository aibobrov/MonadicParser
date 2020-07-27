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

	public init(_ factory: @escaping () -> C) {
		self.factory = factory
	}

	public convenience init(_ factory: @autoclosure @escaping () -> C) {
		self.init(factory)
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

@available(OSX 10.15.0, *)
@inline(__always)
public func lazy<C: Combinator>(_ factory: @autoclosure @escaping () -> C) -> some Combinator {
	return Lazy(factory)
}

@available(OSX 10.15.0, *)
@inline(__always)
public func lazy<C: Combinator>(_ factory: @escaping () -> C) -> some Combinator {
	return Lazy(factory)
}
