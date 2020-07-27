//
//  Option.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 05.07.2020.
//

import Foundation

/// Tries to parse by the given parser. In case of failure returns `default` value.
/// `??` semantics
public struct Option<C: Combinator>: Combinator {
	public typealias Result = C.Result

	public let `default`: Result
	public let combinator: C

	public init(_ default: Result, _ combinator: C) {
		self.default = `default`
		self.combinator = combinator
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, C.Result> {
		let result = try combinator.parse(input)
		switch result {
			case .success:
				return result
			case let .failure(error):
				let processed = ParseInput(stream: input.stream[...], position: input.position)
				return .success(stream: processed, error: error, result: `default`)
		}
	}
}

public func ?? <C: Combinator>(_ combinator: C, _ `default`: C.Result) -> Option<C> {
	return Option(`default`, combinator)
}

@available(OSX 10.15.0, *)
@inline(__always)
public func option<C: Combinator>(_ combinator: C, `default`: C.Result) -> some Combinator {
	return Option(`default`, combinator)
}
