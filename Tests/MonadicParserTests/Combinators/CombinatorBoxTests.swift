//
//  CombinatorBoxTests.swift
//  MonadicParserTests
//
//  Created by Artem Bobrov on 09.07.2020.
//

import XCTest
@testable import MonadicParser

class CombinatorBoxTests: XCTestCase {
	func testBoxedCompilation() {
		let _: [Element.BoxType] = (Element() ++ Element()) ++ (Empty() ++ Empty())
		let _: [Element.BoxType] = Element() ++ Element() ++ Empty() ++ Empty()
		let _: [Element.BoxType] = Element() ++ (Element() ++ Empty() ++ Empty())
	}
}
