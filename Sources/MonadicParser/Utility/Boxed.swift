//
//  Boxed.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 07.07.2020.
//

import Foundation

/// Protocol representing an object that can be boxed
public protocol Boxed {
	associatedtype BoxType

	/// Returned self boxed object
	var boxed: BoxType { get }
}
