//
//  TruthTable.swift
//  BooleanExpression
//
//  Created by Artem Bobrov on 12.07.2020.
//

import Foundation


struct TruthTable {
	struct Element {
		let mask: [Bool]
		let result: Bool
	}
	let identifiers: [String]
	var table: [Element]
}
