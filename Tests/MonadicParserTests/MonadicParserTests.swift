import XCTest
import MonadicParser

final class MonadicParserTests: XCTestCase {
	func testExample() {
		func concat(c1: Character, c2: Character, c3: Character, c4: Character) -> String {
			return "\(c1)\(c2)\(c3)\(c4)"
		}
		let cconcat = curry(concat)

		let element = Element()
		let parser = cconcat <^> element <*> element <*> element <*> element
		let result = try! parser("12312hello")
		XCTAssertSuccessResult(result)
	}

	func testSeparated1() {
		let term = Symbol("n")
		let spaces = Many(Symbol(" "))
		let plus = Between(leading: spaces, trailing: spaces, Symbol("+"))
		let minus = Between(leading: spaces, trailing: spaces, Symbol("-"))
		let separator = plus <|> minus
		let parser = SeparatedBy1(term, separator)

		let result = try! parser("n +  n  +   n   -   n   -    n")
		XCTAssertSuccessResult(result)
	}

	func testChoice() {
		let space = Symbol(" ")
		let plus = Symbol("+")
		let minus = Symbol("-").boxed
		let choice = Choice(space ++ plus ++ minus)
		let result = try! choice("+")
		XCTAssertSuccessResult(result)
	}

	func testKeyword() {
		let keyword = Keyword("as", "as?", "let", "var", "func", "is", "!is", "var", "val", "when", "while")
		let result = try! keyword("as? hello")
		XCTAssertSuccessResult(result, expected: "as?")
	}

	static var allTests = [
		("testExample", testExample),
	]
}
