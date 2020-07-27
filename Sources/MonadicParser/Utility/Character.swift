//
//  Character.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 09.07.2020.
//

import Foundation

public extension Character {
	var isAlpha: Bool {
		return ("a"..."z").contains(lowercased())
	}

	var isDigit: Bool {
		return ("0"..."9").contains(lowercased())
	}
}
