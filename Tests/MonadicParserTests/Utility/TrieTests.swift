//
//  TrieTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 06.07.2020.
//

import XCTest
@testable import MonadicParser

private extension String {
	private static let BASE: Set<Character> = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

	static func random(with lengths: Range<Int>) -> String {
		let length = Int.random(in: lengths)
		let array = (0..<length).map { _ in BASE.randomElement()! }

		return String(array)
	}
}

final class TrieTests: XCTestCase {
	private static let STRESS_TEST_SIZE = 100_000

    func testSimple() throws {
		let trie = Trie("her", "his", "them", "wow", "attack")
		XCTAssertTrue(trie.contains("her"))
		XCTAssertTrue(trie.contains("attack"))
		XCTAssertFalse(trie.contains(""))
		XCTAssertFalse(trie.contains("he"))
		XCTAssertFalse(trie.contains("hem"))
		XCTAssertFalse(trie.contains("ow"))
		XCTAssertTrue(trie.contains("wow"))
    }

	func testComplex() throws {
		let trie = Trie("", "hello", "TrieTests", "xctest", "seconds", "SUCCESSFUL", "handshake", "0x5203")
		XCTAssertTrue(trie.contains(""))
		XCTAssertTrue(trie.contains("hello"))
		XCTAssertTrue(trie.contains("TrieTests"))
		XCTAssertTrue(trie.contains("xctest"))
		XCTAssertTrue(trie.contains("seconds"))
		XCTAssertTrue(trie.contains("SUCCESSFUL"))
		XCTAssertTrue(trie.contains("handshake"))
		XCTAssertTrue(trie.contains("0x5203"))

		XCTAssertFalse(trie.contains("themself"))
		trie.add("themself")
		XCTAssertTrue(trie.contains("themself"))
	}

	func testStress() {
		let ranges = (small: 1..<50, regular: 50..<100, large: 100..<200)

		let strings = (0..<Self.STRESS_TEST_SIZE).map { _ in String.random(with: ranges.regular) }
		let trie = Trie(strings)
		XCTAssertTrue(strings.allSatisfy(trie.contains))
		let notContainsSmall = (0..<Self.STRESS_TEST_SIZE).map { _ in String.random(with: ranges.small) }
		XCTAssertFalse(notContainsSmall.contains(where: { trie.contains($0)  })) /// Do not contain any string that in the `trie`

		let notContainsLarge = (0..<Self.STRESS_TEST_SIZE).map { _ in String.random(with: ranges.large) }
		XCTAssertFalse(notContainsLarge.contains(where: { trie.contains($0)  })) /// Do not contain any string that in the `trie`
	}
}
