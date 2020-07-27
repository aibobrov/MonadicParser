// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import XCTest
@testable import MonadicParserTests

extension BetweenTests {
  static var allTests: [(String, (BetweenTests) -> () throws -> Void)] = [
    ("testSuccess", testSuccess),
    ("testSuccessNotComplete", testSuccessNotComplete),
    ("testFailure", testFailure)
  ]
}
extension ChoiceTests {
  static var allTests: [(String, (ChoiceTests) -> () throws -> Void)] = [
    ("testSuccess", testSuccess),
    ("testSuccessConcatination", testSuccessConcatination),
    ("testFailure", testFailure)
  ]
}
extension CombinatorBoxTests {
  static var allTests: [(String, (CombinatorBoxTests) -> () throws -> Void)] = [
    ("testBoxedCompilation", testBoxedCompilation)
  ]
}
extension CombinatorTests {
  static var allTests: [(String, (CombinatorTests) -> () throws -> Void)] = [
    ("testErrorSubstitute", testErrorSubstitute)
  ]
}
extension ElementTests {
  static var allTests: [(String, (ElementTests) -> () throws -> Void)] = [
    ("testSuccess", testSuccess),
    ("testFailure1", testFailure1),
    ("testFailure2", testFailure2)
  ]
}
extension ExpressionTests {
  static var allTests: [(String, (ExpressionTests) -> () throws -> Void)] = [
    ("testExpressionSimple", testExpressionSimple),
    ("testExpression1", testExpression1),
    ("testExpression2", testExpression2),
    ("testExpression3", testExpression3),
    ("testExpression4", testExpression4)
  ]
}
extension KeywordTests {
  static var allTests: [(String, (KeywordTests) -> () throws -> Void)] = [
    ("testSuccessFullKotlin", testSuccessFullKotlin),
    ("testSuccessFullHaskell", testSuccessFullHaskell),
    ("testSuccessFullC", testSuccessFullC),
    ("testSuccessSuffixKotlin", testSuccessSuffixKotlin),
    ("testSuccessNewlineSuffixHaskell", testSuccessNewlineSuffixHaskell),
    ("testSuccessNewlineSuffixC", testSuccessNewlineSuffixC),
    ("testSuccessNewlineSuffixKotlin", testSuccessNewlineSuffixKotlin),
    ("testSuccessSuffixHaskell", testSuccessSuffixHaskell),
    ("testSuccessSuffixC", testSuccessSuffixC),
    ("testFailurePrefixKotlin", testFailurePrefixKotlin),
    ("testFailurePrefixHaskell", testFailurePrefixHaskell),
    ("testFailurePrefixC", testFailurePrefixC)
  ]
}
extension MonadicParserTests {
  static var allTests: [(String, (MonadicParserTests) -> () throws -> Void)] = [
    ("testExample", testExample),
    ("testSeparated1", testSeparated1),
    ("testChoice", testChoice),
    ("testKeyword", testKeyword)
  ]
}
extension OptionTests {
  static var allTests: [(String, (OptionTests) -> () throws -> Void)] = [
    ("testSuccess1", testSuccess1),
    ("testSuccess2", testSuccess2),
    ("testSuccess3", testSuccess3)
  ]
}
extension ParseResultTests {
  static var allTests: [(String, (ParseResultTests) -> () throws -> Void)] = [
    ("testFunctor", testFunctor),
    ("testMonad1", testMonad1),
    ("testMonad2", testMonad2)
  ]
}
extension PureTests {
  static var allTests: [(String, (PureTests) -> () throws -> Void)] = [
    ("testSuccess", testSuccess)
  ]
}
extension SatisfyTests {
  static var allTests: [(String, (SatisfyTests) -> () throws -> Void)] = [
    ("testExample", testExample),
    ("testPerformanceExample", testPerformanceExample)
  ]
}
extension SeparatedBy1Tests {
  static var allTests: [(String, (SeparatedBy1Tests) -> () throws -> Void)] = [
    ("testSuccess", testSuccess),
    ("testSuccessWithRest1", testSuccessWithRest1),
    ("testFaulure2", testFaulure2)
  ]
}
extension StandardTests {
  static var allTests: [(String, (StandardTests) -> () throws -> Void)] = [
    ("testDigitSuccess", testDigitSuccess),
    ("testDigitSuccess2", testDigitSuccess2),
    ("testDigitFailure", testDigitFailure),
    ("testWordsSuccess1", testWordsSuccess1),
    ("testWordsSuccess2", testWordsSuccess2),
    ("testAlphabetical", testAlphabetical),
    ("testIdentifier", testIdentifier)
  ]
}
extension SymbolTests {
  static var allTests: [(String, (SymbolTests) -> () throws -> Void)] = [
    ("testSuccess", testSuccess),
    ("testFailure1", testFailure1),
    ("testFailure2", testFailure2)
  ]
}
extension TrieTests {
  static var allTests: [(String, (TrieTests) -> () throws -> Void)] = [
    ("testSimple", testSimple),
    ("testComplex", testComplex),
    ("testStress", testStress)
  ]
}
extension VoidTests {
  static var allTests: [(String, (VoidTests) -> () throws -> Void)] = [
    ("testSuccess", testSuccess),
    ("testFailure", testFailure)
  ]
}
extension WordTests {
  static var allTests: [(String, (WordTests) -> () throws -> Void)] = [
    ("testSuccess", testSuccess),
    ("testSuccess2", testSuccess2),
    ("testFailure", testFailure),
    ("testFailure2", testFailure2),
    ("testFailure3", testFailure3)
  ]
}

// swiftlint:disable trailing_comma
XCTMain([
  testCase(BetweenTests.allTests),
  testCase(ChoiceTests.allTests),
  testCase(CombinatorBoxTests.allTests),
  testCase(CombinatorTests.allTests),
  testCase(ElementTests.allTests),
  testCase(ExpressionTests.allTests),
  testCase(KeywordTests.allTests),
  testCase(MonadicParserTests.allTests),
  testCase(OptionTests.allTests),
  testCase(ParseResultTests.allTests),
  testCase(PureTests.allTests),
  testCase(SatisfyTests.allTests),
  testCase(SeparatedBy1Tests.allTests),
  testCase(StandardTests.allTests),
  testCase(SymbolTests.allTests),
  testCase(TrieTests.allTests),
  testCase(VoidTests.allTests),
  testCase(WordTests.allTests),
])
// swiftlint:enable trailing_comma

