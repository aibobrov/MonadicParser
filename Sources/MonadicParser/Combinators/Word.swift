//
//  Word.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 09.07.2020.
//

import Foundation

/// Parses the whole given word in the beginning of the stream
/// Returns the word
public struct Word<Result: StringProtocol>: Combinator {
	public let string: Result

	public init(_ string: Result) {
		self.string = string
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result> {
		var position = input.position

		var streamOffset = input.stream.startIndex
		var stringOffset = string.startIndex

		while streamOffset < input.stream.endIndex && stringOffset < string.endIndex {
			let streamCharacter = input.stream[streamOffset]
			let stringCharacter = string[stringOffset]
			guard streamCharacter == stringCharacter else { break }

			streamOffset = input.stream.index(after: streamOffset)
			stringOffset = string.index(after: stringOffset)
			position = position.processed(streamCharacter)
		}
		guard stringOffset == string.endIndex else {
			return .failure(error: .keywordNotFound(on: input.position))
		}

		return .success(
			stream: ParseInput(stream: input.stream[streamOffset...], position: position),
			error: nil,
			result: string
		)
	}
}

@available(OSX 10.15.0, *)
@inline(__always)
func word<Result: StringProtocol>(_ string: Result) -> some Combinator {
	return Word(string)
}
