//
//  BooleanExpressionParser.swift
//  BooleanExpression
//
//  Created by Artem Bobrov on 09.07.2020.
//

import Foundation
import MonadicParser

struct BooleanExpression: Parser {
	private static let keywords = Keyword(["and", "or", "not", "implies", "true", "false"])
	private static let identifier = Standard.identifier
    typealias Result = BooleanAST


	private let variable = Except(primary: identifier, checker: keywords)
		.map { BooleanAST.identifier($0) }

	private let conjunction = Choice(Word("&&"), Word("∧"), Word("and"), Word("*"), Word(#"\land"#)) ^> BooleanAST.Operator.conjunction

	private let disjunction = Choice(Word("||"), Word("∨"), Word("or"), Word(#"\lor"#)) ^> BooleanAST.Operator.disjunction

	private let negation = Choice(Word("!"), Word("not"), Word("¬"), Word("~"), Word(#"\neg"#)) ^> BooleanAST.Operator.negation

	private let implication = Choice(Word("->"), Word("implies"), Word("→"), Word(#"\to"#)) ^> BooleanAST.Operator.implication

	private let constantTrue = Choice(Word("true"), Word("1")) ^> BooleanAST.constant(true)

	private let constantFalse = Choice(Word("false"), Word("0")) ^> BooleanAST.constant(false)

    var parser: AnyCombinator<BooleanAST> {
		let atom = spaced(variable) <|> spaced(constantTrue) <|> spaced(constantFalse)
		return Expression(
			Lazy(spaced(braced(self.parser))) <|> atom,
            buildUnary,
            buildBinary,
            Operation(operator: implication, type: .binary(.right)) ++
			Operation(operator: disjunction, type: .binary(.left)) ++
			Operation(operator: conjunction, type: .binary(.left)) ++
			Operation(operator: negation, type: .unary)
		).boxed
    }
}

private func spaced<C: Combinator>(_ combinator: C) ->  Between<Many<Character>, Many<Character>, C> {
	let space = Symbol(" ")
	return Between(leading: Many(space), trailing: Many(space), combinator)
}

private func braced<C: Combinator>(_ combinator: C) -> Between<Symbol, Symbol, C> {
	let leftBracket = Symbol("(")
	let rightBracket = Symbol(")")
	return Between(leading: leftBracket, trailing: rightBracket, combinator)
}

private func buildUnary(_ oper: BooleanAST.Operator, _ expression: BooleanAST) -> BooleanAST {
	switch oper {
	case .negation:
		return .negation(expression)
	default:
		fatalError("Unexpected operator type")
	}
}

private func buildBinary(_ lhs: BooleanAST, _ oper: BooleanAST.Operator, _ rhs: BooleanAST) -> BooleanAST {
	switch oper {
	case .conjunction:
		return .conjunction(lhs, rhs)
	case .disjunction:
		return .disjunction(lhs, rhs)
	case .implication:
		return .implication(lhs, rhs)
	default:
		fatalError("Unexpected operator type")
	}
}
