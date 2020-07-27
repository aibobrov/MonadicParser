//
//  SeparatedBy1.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 07.07.2020.
//

import Foundation

// swiftlint:disable line_length

/// Parses one or more occurrences of `term`, separated and optionally ended by `separator`
/// Returns a list of values returned by p.
public struct SeparatedBy1<Term: Combinator, Separator: Combinator>: Parser {
	public typealias ParserType = Monad<Functor<Term, ([(Separator.Result, Term.Result)]) -> SeparatedBy1<Term, Separator>.Separated>, Functor<Many<(Separator.Result, Term.Result)>, SeparatedBy1<Term, Separator>.Separated>>

	public typealias Result = Separated

	public var parser: ParserType

	public init(_ term: Term, _ separator: Separator) {
		let collectFirst = curry(Self.collectTermsSeparators) <^> term
		let collectRest = Many(curry { x, y in (x, y) } <^> separator <*> term)
		parser = collectFirst <*> collectRest
	}
}

public extension SeparatedBy1 {
	struct Separated {
		public static var empty: Separated { Separated(terms: [], separators: []) }

		public fileprivate(set) var terms: [Term.Result]
		public fileprivate(set) var separators: [Separator.Result]

		public init(terms: [Term.Result], separators: [Separator.Result]) {
			self.terms = terms
			self.separators = separators
		}
	}
}

private extension SeparatedBy1 {
	static func collectTermsSeparators(
		_ termResult: Term.Result, restParseResult: [(Separator.Result, Term.Result)]
	) -> Result {
		var terms: [Term.Result] = [termResult]
		terms.reserveCapacity(restParseResult.count + 1)

		var separators: [Separator.Result] = []
		separators.reserveCapacity(restParseResult.count)

		let initial = Separated(terms: terms, separators: separators)
		return restParseResult.reduce(into: initial) { (result, val) in
			result.separators.append(val.0)
			result.terms.append(val.1)
		}
	}
}

extension SeparatedBy1.Separated: Equatable where Term.Result: Equatable, Separator.Result: Equatable {}

@available(OSX 10.15.0, *)
@inline(__always)
public func separatedBy1<Term: Combinator, Separator: Combinator>(
	_ term: Term, _ separator: Separator
) -> some Combinator {
	return SeparatedBy1(term, separator)
}
