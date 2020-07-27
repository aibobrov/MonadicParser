# MonadicParser

Monadic parser combinator library implemented in Swift.

There are some standard combinators like `digit, number natural, word, etc`. Type erasure idiom `AnyCombinator` and some other bicycles are included.

## Usage

```swift
let result = try! Standard.natural("123 hello")
print(result) // .success(stream: ParseInput(stream: " hello", position: (line: 0, column: 3)), error: _), result: 123)
```

## Building and development

* `scripts/generate_currying.py` generates curry functions up to 12 arguments.
  
* `scripts/generate_LinuxMain.sh` generates test runner for platform without Objective-C runtime.

* `scripts/run_docker.sh` pulls and runs swift docker image to test Linux build on macOS.

* SPM friendly commands like `swift build`, `swift test`, ect are working.

## Example

### BooleanExpression

Boolean expression parser with truth table Markdown output.
Run `create_examples.sh` to generate examples.
