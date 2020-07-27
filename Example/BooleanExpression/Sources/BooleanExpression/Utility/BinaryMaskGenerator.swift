//
//  BinaryMaskGenerator.swift
//  BooleanExpression
//
//  Created by Artem Bobrov on 11.07.2020.
//

import Foundation

public struct BinaryMaskGenerator {
	public let length: Int

	public init(length: Int) {
		self.length = length
	}
}

extension BinaryMaskGenerator: Sequence {
	public typealias Element = [Bool]
	public typealias Iterator = BinaryMaskGeneratorIterator
	public func makeIterator() -> Iterator {
		return BinaryMaskGeneratorIterator(length: length)
	}
}

public struct BinaryMaskGeneratorIterator {
	private var stack: [Element] = []

	public init(length: Int) {
		stack.reserveCapacity(1 << length)
		fillStack(
			mask: Array(repeating: false, count: length),
			index: 0
		)
		stack.reverse()
	}

	private mutating func fillStack(mask: Element, index: Int) {
		if index == mask.count {
			stack.append(mask)
			return
		}
		var mask = mask

		mask[index] = false
		fillStack(mask: mask, index: index + 1)

		mask[index] = true
		fillStack(mask: mask, index: index + 1)
	}
}

extension BinaryMaskGeneratorIterator: IteratorProtocol {
	public typealias Element = [Bool]

	public mutating func next() -> [Bool]? {
		return stack.popLast()
	}
}


func binaryMasks(length: Int) -> BinaryMaskGenerator {
	return BinaryMaskGenerator(length: length)
}
