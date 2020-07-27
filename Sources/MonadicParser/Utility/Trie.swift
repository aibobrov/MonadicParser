//
//  Trie.swift
//  MonadicParser
//
//  Created by Artem Bobrov on 06.07.2020.
//

import Foundation

/// Simple prefix tree for checking whether a string contains in a set of words.
internal struct Trie<StringType: StringProtocol> {
	internal let root: Node = .root()

	internal init<S: Sequence>(_ dictionary: S) where S.Element == StringType {
		dictionary.forEach(self.add)
	}

	internal init(_ words: StringType...) {
		self.init(words)
	}

	/// Checks whether the `string` contains in the trie.
	/// Complexity: ~O(|string|)~
	/// - Parameter string: string to add
	@inlinable
	internal func contains(_ string: StringType) -> Bool {
		return root.contains(string)
	}

	/// Adds `string` to the trie.
	/// Complexity: ~O(|string|)~
	/// - Parameter string: string to add
	@inlinable
	internal func add(_ string: StringType) {
		return root.add(string)
	}
}

internal extension Trie {
	final class Node {
		typealias Element = StringType.Element

		fileprivate static func root() -> Node {
			return Node(childred: [:], isTerminated: false)
		}

		var childred: [Element: Node]
		var isTerminated: Bool

		fileprivate init(childred: [Element: Node], isTerminated: Bool) {
			self.childred = childred
			self.isTerminated = isTerminated
		}
	}
}

fileprivate extension Trie.Node {
	/// Finds the deepest node for given `string`.
	/// If `string` \notin `Trie` than returns `nil`
	static func findPrefixEnd<S: StringProtocol>(_ root: Trie.Node, _ string: S) -> Trie.Node? {
		var node = root
		for character in string {
			guard let nextNode = node.childred[character] else {
				return nil
			}
			node = nextNode
		}
		return node
	}

	/// Find the deepest node for the longest string prefix.
	/// Return deepest node and smallest suffix of the `string`
	/// If `string` \notin `Trie` than returns `root` and empty subtring
	static func lastNode<S: StringProtocol>(_ root: Trie.Node, _ string: S) -> (node: Trie.Node, string: S.SubSequence) {
		var node = root

		for offset in string.indices {
			let character = string[offset]
			guard let nextNode = node.childred[character] else {
				return (node, string[offset...])
			}
			node = nextNode
		}
		return (node, string[string.endIndex...])
	}
}

extension Trie.Node {
	@inlinable func add(_ string: StringType) {
		var (node, suffix) = Trie.Node.lastNode(self, string)
		for character in suffix {
			let newNode = Trie.Node(childred: [:], isTerminated: false)
			node.childred[character] = newNode
			node = newNode
		}
		node.isTerminated = true
	}

	@inlinable func contains(_ string: StringType) -> Bool {
		guard let node: Trie.Node = .findPrefixEnd(self, string) else {
			return false
		}
		return node.isTerminated
	}
}
