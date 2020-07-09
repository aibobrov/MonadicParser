//
//  KeywordTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 07.07.2020.
//

@testable import MonadicParser
import XCTest

class KeywordTests: XCTestCase {
    func testSuccessFullKotlin() {
        let kotlinKWParser = Keyword(Self.kotlinKeywords)

        for keyword in Self.kotlinKeywords {
            let result = try! kotlinKWParser(keyword)
            let restInput: ParseInput<Substring> = ParseInput(
                stream: "",
                position: .init(line: 0, column: UInt(keyword.count))
            )
            XCTAssertSuccessResult(result, expected: (restInput, keyword))
        }
    }

    func testSuccessFullHaskell() {
        let haskellKWParser = Keyword(Self.cKeywords)

        for keyword in Self.cKeywords {
            let result = try! haskellKWParser(keyword)
            let restInput: ParseInput<Substring> = ParseInput(
                stream: "",
                position: .init(line: 0, column: UInt(keyword.count))
            )
            XCTAssertSuccessResult(result, expected: (restInput, keyword))
        }
    }


	func testSuccessFullC() {
		let cKWParser = Keyword(Self.cKeywords)

		for keyword in Self.cKeywords {
			let result = try! cKWParser(keyword)
			let restInput: ParseInput<Substring> = ParseInput(
				stream: "",
				position: .init(line: 0, column: UInt(keyword.count))
			)
			XCTAssertSuccessResult(result, expected: (restInput, keyword))
		}
	}


    func testSuccessSuffixKotlin() {
        let kotlinKWParser = Keyword(Self.kotlinKeywords)

        for keyword in Self.kotlinKeywords {
            let result = try! kotlinKWParser(keyword + Self.suffix)
            let restInput: ParseInput<Substring> = ParseInput(
                stream: Substring(Self.suffix),
                position: .init(line: 0, column: UInt(keyword.count))
            )
            XCTAssertSuccessResult(result, expected: (restInput, keyword))
        }
    }

    func testSuccessNewlineSuffixHaskell() {
        let haskellKWParser = Many(Symbol("\n")) *> Keyword(Self.haskellKeywords)

        for keyword in Self.haskellKeywords {
            let result = try! haskellKWParser("\n\n" + keyword + Self.suffix)
            let restInput: ParseInput<Substring> = ParseInput(
                stream: Substring(Self.suffix),
                position: .init(line: 2, column: UInt(keyword.count))
            )
            XCTAssertSuccessResult(result, expected: (restInput, keyword))
        }
    }

	func testSuccessNewlineSuffixC() {
		let cKWParser = Many(Symbol("\n")) *> Keyword(Self.cKeywords)

		for keyword in Self.cKeywords {
			let result = try! cKWParser("\n\n" + keyword + Self.suffix)
			let restInput: ParseInput<Substring> = ParseInput(
				stream: Substring(Self.suffix),
				position: .init(line: 2, column: UInt(keyword.count))
			)
			XCTAssertSuccessResult(result, expected: (restInput, keyword))
		}
	}

    func testSuccessNewlineSuffixKotlin() {
        let kotlinKWParser = Many(Symbol("\n")) *> Keyword(Self.kotlinKeywords)

        for keyword in Self.kotlinKeywords {
            let result = try! kotlinKWParser("\n\n" + keyword + Self.suffix)
            let restInput: ParseInput<Substring> = ParseInput(
                stream: Substring(Self.suffix),
                position: .init(line: 2, column: UInt(keyword.count))
            )
            XCTAssertSuccessResult(result, expected: (restInput, keyword))
        }
    }

    func testSuccessSuffixHaskell() {
        let haskellKWParser = Keyword(Self.haskellKeywords)

        for keyword in Self.haskellKeywords {
            let result = try! haskellKWParser(keyword + Self.suffix)
            let restInput: ParseInput<Substring> = ParseInput(
                stream: Substring(Self.suffix),
                position: .init(line: 0, column: UInt(keyword.count))
            )
            XCTAssertSuccessResult(result, expected: (restInput, keyword))
        }
    }


	func testSuccessSuffixC() {
		let cKWParser = Keyword(Self.cKeywords)

		for keyword in Self.cKeywords {
			let result = try! cKWParser(keyword + Self.suffix)
			let restInput: ParseInput<Substring> = ParseInput(
				stream: Substring(Self.suffix),
				position: .init(line: 0, column: UInt(keyword.count))
			)
			XCTAssertSuccessResult(result, expected: (restInput, keyword))
		}
	}

    func testFailurePrefixKotlin() {
        let kotlinKWParser = Keyword(Self.kotlinKeywords)

        for keyword in Self.kotlinKeywords {
            let result = try! kotlinKWParser(Self.prefix + keyword)
            XCTAssertFailureResult(result)
        }
    }

    func testFailurePrefixHaskell() {
        let haskellKWParser = Keyword(Self.haskellKeywords)

        for keyword in Self.haskellKeywords {
            let result = try! haskellKWParser(Self.prefix + keyword)
            XCTAssertFailureResult(result)
        }
    }

	func testFailurePrefixC() {
		let cKWParser = Keyword(Self.cKeywords)

		for keyword in Self.cKeywords {
			let result = try! cKWParser(Self.prefix + keyword)
			XCTAssertFailureResult(result)
		}
	}
}

private extension KeywordTests {
    static let suffix = "suffix"
    static let prefix = "prefix"

    static let kotlinKeywords: [String] = ["as",
                                           "as?",
                                           "break",
                                           "class",
                                           "continue",
                                           "do",
                                           "else",
                                           "false",
                                           "for",
                                           "fun",
                                           "if",
                                           "in",
                                           "!in",
                                           "interface",
                                           "is",
                                           "!is",
                                           "null",
                                           "object",
                                           "package",
                                           "return",
                                           "super",
                                           "this",
                                           "throw",
                                           "true",
                                           "try",
                                           "typealias",
                                           "typeof",
                                           "val",
                                           "var",
                                           "when",
                                           "while"]

    static let haskellKeywords: [String] = ["as",
                                            "case",
                                            "of",
                                            "class",
                                            "data",
                                            "data family",
                                            "data instance",
                                            "default",
                                            "deriving",
                                            "deriving instance",
                                            "do",
                                            "forall",
                                            "foreign",
                                            "hiding",
                                            "if",
                                            "then",
                                            "else",
                                            "import",
                                            "infix",
                                            "infixl",
                                            "infixr",
                                            "instance",
                                            "let",
                                            "in",
                                            "mdo",
                                            "module",
                                            "newtype",
                                            "proc",
                                            "qualified",
                                            "rec",
                                            "type",
                                            "type family",
                                            "type instance",
                                            "where"]

    static let cKeywords: [String] = ["auto",
                                      "break",
                                      "case",
                                      "char",
                                      "const",
                                      "continue",
                                      "default",
                                      "do",
                                      "double",
                                      "else",
                                      "enum",
                                      "extern",
                                      "float",
                                      "for",
                                      "goto",
                                      "if",
                                      "int",
                                      "long",
                                      "register",
                                      "return",
                                      "short",
                                      "signed",
                                      "sizeof",
                                      "static",
                                      "struct",
                                      "switch",
                                      "typedef",
                                      "union",
                                      "unsigned",
                                      "void",
                                      "volatile",
                                      "while"]
}
