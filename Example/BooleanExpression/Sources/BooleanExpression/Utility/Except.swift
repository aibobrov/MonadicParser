//
//  Except.swift
//  BooleanExpression
//
//  Created by Artem Bobrov on 12.07.2020.
//

import Foundation
import MonadicParser

public struct Except<Primary: Combinator, Checker: Combinator>: Combinator where Primary.Result: StringProtocol {
	public typealias Result = Primary.Result
	public let primary: Primary
	public let checker: Checker

	public init(primary: Primary, checker: Checker) {
		self.primary = primary
		self.checker = checker
	}

	public
	func parse<Stream: StringProtocol>(_ input: ParseInput<Stream>) throws -> ParseResult<Stream.SubSequence, Result>  {
		let primaryResult = try primary.parse(input)
		switch primaryResult {
			case .failure:
				return primaryResult
			case let .success(_, _, result):
				let checkerResult = try checker(result)
				switch checkerResult {
					case .failure:
						return primaryResult
					case .success:
						return .failure(error: .custom("Unexpected success"))
				}
		}
	}
}
