//
//  TruthTableReportGenerator.swift
//  BooleanExpression
//
//  Created by Artem Bobrov on 12.07.2020.
//

import Foundation

enum OutputTruthTable {
	case constant(_ flag: Bool)
	case table(TruthTable)
}

protocol TruthTableReportGenerator {
	typealias OutputType = TruthTableGenerator.OutputType
	func generate(for table: OutputTruthTable, expression: String)
}

func reportGenerator(for outputType: TruthTableGenerator.OutputType) -> TruthTableReportGenerator {
	switch outputType {
		case .markdown:
			return DummyMarkdownGenerator()
		case .silent:
			return SilentReportGenerator()
	}
}

private struct SilentReportGenerator: TruthTableReportGenerator {
	func generate(for table: OutputTruthTable, expression: String) {}
}

private struct DummyMarkdownGenerator: TruthTableReportGenerator {
	func generate(for table: OutputTruthTable, expression: String) {

		let content = """
		# Truth table

		\(represent(table, expression: expression))
		"""
		print(content)
	}

	private func represent(_ table: OutputTruthTable, expression: String) -> String {
		switch table {
			case let .constant(flag):
				return "Constant \(flag)"
			case let .table(table):
				return represent(table, expression: expression)
		}
	}

	private func represent(_ table: TruthTable, expression: String) -> String {
		let header = "| \(table.identifiers.joined(separator: " | ")) | $\(expression)$ |"
		let separator = "|\(Array(repeating: "-", count: table.identifiers.count ).joined(separator: "|"))|:-:|"
		let body = table.table
			.map { element in
				let identifiersColumns = element.mask
					.map(represent)
					.joined(separator: " | ")
				return "| \(identifiersColumns) | \(represent(element.result)) |"
			}
			.joined(separator: "\n")
		return "\(header)\n\(separator)\n\(body)"
	}

	private func represent(_ bool: Bool) -> String {
		return bool ? "1" : "0"
	}
}
