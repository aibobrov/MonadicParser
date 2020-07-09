//
//  ParseInput.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 30.06.2020.
//

import Foundation

/// Structure of the given parsing input
public struct ParseInput<Stream: StringProtocol>: Equatable {
	public let stream: Stream

	public let position: Position

	@inlinable
	public init(stream: Stream, position: Position) {
		self.stream = stream
		self.position = position
	}
}
