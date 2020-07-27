#!/usr/bin/env bash

swift build

.build/debug/BooleanExpression 'A -> B' > output-examples/basic.md

.build/debug/BooleanExpression '((a \land b) \lor ((\neg a) \land (\neg b))) \to ((a \to b) \land (b \to a))' > output-examples/latex_expression_1.md

.build/debug/BooleanExpression '((a \land (\neg b)) \lor ((\neg a) \land b)) \land a \land b' > output-examples/latex_expression_2.md

.build/debug/BooleanExpression '((!(a \to (!(b && d)))) \land (d and (b or c)))' > output-examples/latex_expression_3.md
