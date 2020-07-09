//
//  Satisfy.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 28.06.2020.
//

import Foundation

/// Tries to parse the next symbol of the stream. Accepts the symbol in case of `predicate(symbol)` is `true`
public struct Satisfy: Combinator {
	public typealias Result = Character
	public typealias Predicate = (Character) -> Bool

	private let predicate: Predicate

	public init(predicate: @escaping Predicate) {
		self.predicate = predicate
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		if let element = input.stream.first, predicate(element) {
			let processed = ParseInput(stream: input.stream.dropFirst(), position: input.position.processed(element))
			return .success(stream: processed, error: nil, result: element)
		}
		return .failure(error: .predicateFailure(on: input.position))
	}
}

@available(OSX 10.15.0, *)
@inline(__always)
func satisfy(predicate: @escaping Satisfy.Predicate) -> some Combinator {
	return Satisfy(predicate: predicate)
}
