
//
//  ExpressionTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

@testable import MonadicParser
import XCTest

private indirect enum ExpressionAST: Equatable, CustomDebugStringConvertible {
	typealias Number = UInt
	case plus(_ lhs: ExpressionAST, _ rhs: ExpressionAST)
	case minus(_ lhs: ExpressionAST, _ rhs: ExpressionAST)
	case mult(_ lhs: ExpressionAST, _ rhs: ExpressionAST)
	case divide(_ lhs: ExpressionAST, _ rhs: ExpressionAST)
	case equality(_ lhs: ExpressionAST, _ rhs: ExpressionAST)
	case conjunction(_ lhs: ExpressionAST, _ rhs: ExpressionAST)
	case negate(_ value: ExpressionAST)
	case number(_ value: Number)

	var debugDescription: String {
		return buildString(self)
	}
}

private func buildString(_ expression: ExpressionAST, level: Int = 0) -> String {
	var string = ""
	if level > 0 {
		string += Array(repeating: "| ", count: level - 1).joined() + "|_"
	}
	switch expression {
		case let .plus(lhs, rhs):
			string += "+\n"
			string += buildString(lhs, level: level + 1)
			string += buildString(rhs, level: level + 1)
		case let .minus(lhs, rhs):
			string += "-\n"
			string += buildString(lhs, level: level + 1)
			string += buildString(rhs, level: level + 1)
		case let .mult(lhs, rhs):
			string += "*\n"
			string += buildString(lhs, level: level + 1)
			string += buildString(rhs, level: level + 1)
		case let .divide(lhs, rhs):
			string += "/\n"
			string += buildString(lhs, level: level + 1)
			string += buildString(rhs, level: level + 1)
		case let .equality(lhs, rhs):
			string += "==\n"
			string += buildString(lhs, level: level + 1)
			string += buildString(rhs, level: level + 1)
		case let .conjunction(lhs, rhs):
			string += "&&\n"
			string += buildString(lhs, level: level + 1)
			string += buildString(rhs, level: level + 1)
		case let .negate(expr):
			string += "!\n"
			string += buildString(expr, level: level + 1)
		case let .number(num):
			string += String(num) + "\n"
	}
	return string
}

private enum Operator: Equatable {
	case plus
	case minus
	case mult
	case divide
	case negate
	case equality
	case conjunction
}


private func buildUnary(_ operator: Operator, _ expression: ExpressionAST) -> ExpressionAST {
	switch `operator` {
		case .negate:
			return .negate(expression)
		default:
			XCTFail("unexpected operator type")
			fatalError()
	}
}

private func buildBinary(_ lhs: ExpressionAST, _ operator: Operator, _ rhs: ExpressionAST) -> ExpressionAST {
	switch `operator` {
		case .plus:
			return .plus(lhs, rhs)
		case .minus:
			return .minus(lhs, rhs)
		case .mult:
			return .mult(lhs, rhs)
		case .divide:
			return .divide(lhs, rhs)
		case .conjunction:
			return .conjunction(lhs, rhs)
		case .equality:
			return .equality(lhs, rhs)
		default:
			XCTFail("unexpected operator type")
			fatalError()
	}
}

class ExpressionTests: XCTestCase {
	private var expression: Expression<Alternative<ExpressionAST>, AnyCombinator<Operator>, ExpressionAST> {
		let space = Symbol(" ")
		func spaced<C: Combinator>(_ combinator: C) -> Between<Many<Symbol.Result>, Many<Symbol.Result>, C> {
			return Between(leading: Many(space), trailing: Many(space), combinator)
		}

		let leftBracket = Word("(")
		let rightBracket = Word(")")
		let negate = spaced(Word("!")) ^> Operator.negate
		let plus = spaced(Word("+")) ^> Operator.plus
		let minus = spaced(Word("-")) ^> Operator.minus
		let mult = spaced(Word("*")) ^> Operator.mult
		let divide = spaced(Word("/")) ^> Operator.divide
		let equality = spaced(Word("==")) ^> Operator.equality
		let conjunction = spaced(Word("&&")) ^> Operator.conjunction
		let number = Standart.natural.map { ExpressionAST.number($0) }
		let term = number <|> Between(leading: leftBracket, trailing: rightBracket, Lazy(self.expression))
		return Expression(
			term,
			buildUnary,
			buildBinary,
			Operation(operator: equality, type: .binary(.none)) ++
			Operation(operator: conjunction, type: .binary(.right)) ++
			Operation(operator: plus <|> minus, type: .binary(.left)) ++
			Operation(operator: mult <|> divide, type: .binary(.left)) ++
			Operation(operator: negate, type: .unary)
		)
	}

	func testExpressionSimple() {
		let result = try! expression("1+1+2")
		let expected: ExpressionAST = .plus(.plus(.number(1), .number(1)), .number(2))

		XCTAssertSuccessResult(result, expected: expected)
	}


	func testExpression1() {
		let result = try! expression("1+1*2")
		let expected: ExpressionAST = .plus(.number(1), .mult(.number(1), .number(2)))

		XCTAssertSuccessResult(result, expected: expected)
	}


	func testExpression2() {
		let result = try! expression("1  / 2 / 3")
		let expected: ExpressionAST = .divide(.divide(.number(1), .number(2)), .number(3))

		XCTAssertSuccessResult(result, expected: expected)
	}


	func testExpression3() {
		let result = try! expression("344 - !(1123 * 2123) +  4234 / 342 - 90998 * 0 - 1")
		let expected: ExpressionAST = .minus(
			.minus(
				.plus(
					.minus(
						.number(344),
						.negate(
							.mult(
								.number(1123),
								.number(2123)
							)
						)
					),
					.divide(
						.number(4234),
						.number(342)
					)
				),
				.mult(
					.number(90998),
					.number(0)
				)
			),
			.number(1)
		)

		XCTAssertSuccessResult(result, expected: expected)
	}

	func testExpression4() {
		let result = try! expression("1  && 0 - 2 == 234 - 234 && 324")

		let expected: ExpressionAST = .equality(
			.conjunction(
				.number(1),
				.minus(
					.number(0),
					.number(2)
				)
			),
			.conjunction(
				.minus(
					.number(234),
					.number(234)
				),
				.number(324)
			)
		)

		XCTAssertSuccessResult(result, expected: expected)
	}
}
