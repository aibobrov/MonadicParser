//
//  Keyword.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 05.07.2020.
//

import Foundation

/// Parses the longest string from the given dictionary.
/// Returns the matched string.
public struct Keyword: Combinator {
	public typealias Result = String

	private let trie: Trie<Result>

	public init(_ dictionary: [Result]) {
		trie = Trie(dictionary)
	}

	public init(_ strings: Result...) {
		self.init(strings)
	}

	public func parse<Stream: StringProtocol>(
		_ input: ParseInput<Stream>
	) throws -> ParseResult<Stream.SubSequence, Result> {
		var position = input.position
		var node = trie.root
		var latestKeywordOffset: Stream.Index?
		var latestKeywordPosition: Position?

		if node.isTerminated {
			latestKeywordOffset = input.stream.startIndex
			latestKeywordPosition = position
		}

		for offset in input.stream.indices {
			let character = input.stream[offset]

			guard let nextNode = node.childred[character] else {
				break
			}

			node = nextNode
			position = position.processed(character)

			if node.isTerminated {
				latestKeywordOffset = input.stream.index(after: offset)
				latestKeywordPosition = position
			}
		}

		guard let keywordOffset = latestKeywordOffset,
			  let keywordPosition = latestKeywordPosition else {
			return .failure(error: .keywordNotFound(on: position))
		}

		return .success(
			stream: ParseInput(stream: input.stream[keywordOffset...], position: keywordPosition),
			error: nil,
			result: String(input.stream[..<keywordOffset])
		)
	}
}

@available(OSX 10.15.0, *)
@inline(__always)
public func keyword(_ dictionary: [Keyword.Result]) -> some Combinator {
	return Keyword(dictionary)
}

@available(OSX 10.15.0, *)
@inline(__always)
public func keyword(_ dictionary: Keyword.Result...) -> some Combinator {
	return Keyword(dictionary)
}
