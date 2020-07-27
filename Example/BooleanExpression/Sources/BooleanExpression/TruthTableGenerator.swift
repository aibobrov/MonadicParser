//
//  TruthTableGenerator.swift
//  BooleanExpression
//
//  Created by Artem Bobrov on 09.07.2020.
//

import ArgumentParser
import Foundation

struct TruthTableGenerator: ParsableCommand {
    enum OutputType: String, ExpressibleByArgument {
        case markdown
        case silent
    }

    @Option(name: .shortAndLong, help: "Truth table output style")
    var outputType: OutputType = .markdown

    @Argument(help: "Expression string to build the truth table")
    var expression: String

    func run() throws {
		let report = reportGenerator(for: outputType)
		let parser = BooleanExpression()
		let result = try parser(expression)
		switch result {
			case let .failure(error):
				throw error
			case let .success(_, _, ast):
				let identifiers = ast.identifiers().sorted()
				guard !identifiers.isEmpty else {
					let result = ast.execute(using: [:])!
					report.generate(for: .constant(result), expression: expression)
					return
				}
				var truthTable = TruthTable(identifiers: identifiers, table: [])
				
				for mask in binaryMasks(length: identifiers.count) {
					let environment = Dictionary(uniqueKeysWithValues: zip(identifiers, mask))
					guard let expressionResult = ast.execute(using: environment) else {
						fatalError("invalid environment")
					}
					truthTable.table.append(.init(mask: mask, result: expressionResult))
				}

				report.generate(for: .table(truthTable), expression: expression)
		}
	}
}
