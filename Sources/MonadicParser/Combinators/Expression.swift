//
//  Expression.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 07.07.2020.
//

import Foundation

/// Operator information
public enum OperatorType {
	/// Associativity of the operator
	public enum Associativity: Int {
		case left
		case right
		case none
	}

	case binary(_ associativity: Associativity)
	case unary
}

public struct Operation<Operator: Combinator> {
	public let `operator`: Operator
	public let type: OperatorType

	public init(`operator`: Operator, `type`: OperatorType) {
		self.operator = `operator`
		self.type = type
	}

	public var pair: (Operator, OperatorType) { (`operator`, type) }
}

/// Parses expression for given operator and operator parsers
/// Returns AST built by `UnaryBuilder` and `BinaryBuilder`
public struct Expression<Term: Combinator, Operator: Combinator, AST>: Parser where Term.Result == AST {
	public typealias UnaryBuilder = (Operator.Result, _ ast: AST) -> AST
	public typealias BinaryBuilder = (_ lhs: AST, Operator.Result, _ rhs: AST) -> AST

	public typealias ParserType = AnyCombinator<AST>
	public typealias Result = AST

	public let parser: ParserType

	/// Constructor of `Expression parser`
	/// - Parameters:
	///   - term: Term parser
	///   - unary: Function for building the unary operation AST nodes
	///   - binary: Function for building the binary operation AST nodes
	///   - operators: Collection of operator and it's information. The lower index of operator the lower the priority
	public init<C: Collection>(
		_ term: Term, _ unary: @escaping UnaryBuilder, _ binary: @escaping BinaryBuilder, _ operators: C
	) where C.Element == Operation<Operator> {
		parser = Self.buildParser(term, unary, binary, operators)
	}

	/// Constructor of `Expression parser`
	/// - Parameters:
	///   - term: Term parser
	///   - unary: Function for building the unary operation AST nodes
	///   - binary: Function for building the binary operation AST nodes
	///   - operators: Collection of operator and it's information. The lower index of operator the lower the priority
	public init<C: Collection>(
		_ term: Term, _ unary: @escaping UnaryBuilder, _ binary: @escaping BinaryBuilder, _ operators: C
	) where C.Element == (Operator, OperatorType) {
		self.init(term, unary, binary, operators.lazy.map { Operation(operator: $0.0, type: $0.1) })
	}

	/// Constructor of `Expression parser`
	/// - Parameters:
	///   - term: Term parser
	///   - unary: Function for building the unary operation AST nodes
	///   - binary: Function for building the binary operation AST nodes
	///   - operators: Collection of operator and it's information. The lower index of operator the lower the priority
	public init(
		_ term: Term,
		_ unary: @escaping UnaryBuilder,
		_ binary: @escaping BinaryBuilder,
		_ operators: Operation<Operator>...
	) {
		self.init(term, unary, binary, operators)
	}

	/// Constructor of `Expression parser`
	/// - Parameters:
	///   - term: Term parser
	///   - unary: Function for building the unary operation AST nodes
	///   - binary: Function for building the binary operation AST nodes
	///   - operators: Collection of operator and it's information. The lower index of operator the lower the priority
	public init(
		_ term: Term,
		_ unary: @escaping UnaryBuilder,
		_ binary: @escaping BinaryBuilder,
		_ operators: (Operator, OperatorType)...
	) {
		self.init(term, unary, binary, operators)
	}
}

private extension Expression {
	static func buildParser<C: Collection>(
		_ term: Term, _ unary: @escaping UnaryBuilder, _ binary: @escaping BinaryBuilder, _ operators: C
	) -> AnyCombinator<AST> where C.Element == Operation<Operator> {
		guard let first = operators.first else {
			return term.boxed
		}
		let rest = buildParser(term, unary, binary, operators.dropFirst())
		switch first.pair {
			case let (`operator`, .unary):
				let parser = `operator`.map(curry(unary)) <*> rest
				return (parser <|> rest).boxed
			case let (`operator`, .binary(.left)):
				let separated = SeparatedBy1(rest, `operator`)

				let parser = separated.map { $0.foldLeft1(binary) }
				return (parser <|> rest).boxed
			case let (`operator`, .binary(.right)):
				let separated = SeparatedBy1(rest, `operator`)

				let parser = separated.map { $0.foldRight1(binary) }
				return (parser <|> rest).boxed
			case let (`operator`, .binary(.none)):
				let parser = rest.flatMap { lhs in
					`operator` >>= { curry(binary)(lhs)($0) <^> rest }
				}
				return (parser <|> rest).boxed
		}
	}
}

extension Operation: Boxed {
	public typealias BoxType = Operation<Operator.BoxType>

	public var boxed: BoxType {
		return BoxType(operator: `operator`.boxed, type: type)
	}
}

public extension SeparatedBy1.Separated {
	func foldLeft1(
		_ builder: (Term.Result, Separator.Result, Term.Result) throws -> Term.Result
	) rethrows -> Term.Result {
		guard var result = terms.first else {
			assertionFailure()
			fatalError("Folding is unavailable on empty `terms`")
		}
		for offset in terms.indices.dropLast() {
			result = try builder(result, separators[offset], terms[offset + 1])
		}
		return result
	}

	func foldRight1(
		_ builder: (Term.Result, Separator.Result, Term.Result) throws -> Term.Result
	) rethrows -> Term.Result {
		guard var result = terms.last else {
			assertionFailure()
			fatalError("Folding is unavailable on empty `terms`")
		}

		for offset in terms.indices.dropLast().reversed() {
			result = try builder(terms[offset], separators[offset], result)
		}
		return result
	}
}

@available(OSX 10.15.0, *)
@inline(__always)
public func expression<Term: Combinator, Operator: Combinator, AST, C: Collection>(
	_ term: Term,
	_ unary: @escaping Expression<Term, Operator, AST>.UnaryBuilder,
	_ binary: @escaping Expression<Term, Operator, AST>.BinaryBuilder,
	_ operators: C
) -> some Combinator where C.Element == Operation<Operator> {
	return Expression(term, unary, binary, operators)
}

@available(OSX 10.15.0, *)
@inline(__always)
public func expression<Term: Combinator, Operator: Combinator, AST, C: Collection>(
	_ term: Term,
	_ unary: @escaping Expression<Term, Operator, AST>.UnaryBuilder,
	_ binary: @escaping Expression<Term, Operator, AST>.BinaryBuilder,
	_ operators: C
) -> some Combinator where C.Element == (Operator, OperatorType) {
	return Expression(term, unary, binary, operators)
}

@available(OSX 10.15.0, *)
@inline(__always)
public func expression<Term: Combinator, Operator: Combinator, AST, C: Collection>(
	_ term: Term,
	_ unary: @escaping Expression<Term, Operator, AST>.UnaryBuilder,
	_ binary: @escaping Expression<Term, Operator, AST>.BinaryBuilder,
	_ operators: Operation<Operator>...
) -> some Combinator {
	return Expression(term, unary, binary, operators)
}

@available(OSX 10.15.0, *)
@inline(__always)
public func expression<Term: Combinator, Operator: Combinator, AST, C: Collection>(
	_ term: Term,
	_ unary: @escaping Expression<Term, Operator, AST>.UnaryBuilder,
	_ binary: @escaping Expression<Term, Operator, AST>.BinaryBuilder,
	_ operators: (Operator, OperatorType)...
) -> some Combinator {
	return Expression(term, unary, binary, operators)
}
