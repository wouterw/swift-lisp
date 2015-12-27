import Foundation

// Parse the string into an AST.

func read(str: String) -> String {
  return str
}

// Walk the AST and evaluate it.

func eval(ast: String) -> String {
  return ast
}

// Convert the value into a human-readable string for printing.

func _print(exp: String) -> String {
  return exp
}

// READ/EVAL.

func re(text: String) -> String {
  let ast = read(text)
  let exp = eval(ast)

  return exp
}

// READ/EVAL/PRINT.

func rep(text: String) -> String {
  let exp = re(text)

  return _print(exp)
}

// READ/EVAL/PRINT/LOOP.

func repl() {
  while true {
    printPrompt()
    if let text = readLine() {
      print(rep(text))
    } else {
      print("Bye for now!")
      break
    }
  }
}

func printPrompt() {
  print("user=> ", terminator: "")
}
