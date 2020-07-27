//
//  Empty.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 02.07.2020.
//

import Foundation

/// Always failing parser
public struct Empty<Result>: Combinator {
	@inline(__always)
	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		return .failure(error: .undefined(on: input.position))
	}
}
