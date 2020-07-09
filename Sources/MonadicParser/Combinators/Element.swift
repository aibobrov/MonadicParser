//
//  Element.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 30.06.2020.
//

import Foundation

/// Parses next element of the given stream
public struct Element: Parser {
	public typealias ParserType = Satisfy
	public typealias Result = Satisfy.Result

	public let parser: ParserType

	public init() {
		parser = Satisfy(predicate: { _ in true })
	}
}
