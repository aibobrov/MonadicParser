//
//  Utility.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 04.07.2020.
//

import Foundation

@inline(never)
@usableFromInline
internal func abstract(file: StaticString = #file, line: UInt = #line) -> Never {
	fatalError("Method must be overridden", file: file, line: line)
}
