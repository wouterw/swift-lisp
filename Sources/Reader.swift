import Foundation

let tokenPattern =
  "[[:space:],]*" +                     // Skip whitespace: a sequence of zero or more commas or [:space:]'s
  "(" +
    "~@" +                              // Literal "~@"
    "|" +
    "[\\[\\]{}()`'~^@]" +               // Punctuation: Any one of []{}()`'~^@
    "|" +
    "\"(?:\\\\.|[^\\\\\"])*\"" +        // Quoted string: characters other than \ or ", or any escaped characters
    "|" +
    ";.*" +                             // Comment: semicolon followed by anything
    "|" +
    "[^[:space:]\\[\\]{}()`'\",;]*" +   // Symbol, keyword, number, nil, true, false: any sequence of chars but [:space:] or []{}()`'",;
  ")"

let tokenRegex = try! NSRegularExpression(pattern: tokenPattern, options: [])

let atomPattern = [
  "comment": Regex(pattern: "(^;.*$)"),
  "integer": Regex(pattern: "(^-?[0-9]+$)"),
  "float":   Regex(pattern: "(^-?[0-9][0-9.]*$)"),
  "nil":     Regex(pattern: "(^nil$)"),
  "true":    Regex(pattern: "(^true$)"),
  "false":   Regex(pattern: "(^false$)"),
  "string":  Regex(pattern: "(^\".*\"$)"),
  "keyword": Regex(pattern: "(:.*)"),
  "symbol":  Regex(pattern: "(^[^\"]*$)"),
]

func tokenize(s: String) -> [String] {
  let nss = s as NSString
  let all = NSRange(location: 0, length: s.characters.count)

  return tokenRegex
    .matchesInString(s, options: [], range: all)
    .filter { $0.range.length > 0 }
    .map { nss.substringWithRange($0.range) }
}

class Reader {
  let position: Int = 0
  let tokens: [String]

  init(tokens: [String]) {
    self.tokens = tokens
  }

  func peek() -> String? {
    return position < tokens.count ? tokens[position] : nil
  }

  func next() -> String? {
    position += 1
    return peek()
  }
}

func readString(s: String) -> String {
  let tokens = tokenize(s)
  let reader = Reader(tokens)

  return readForm(reader)
}

func readForm(r: Reader) -> Form {
  switch let token = r.peek() {
  case let "(": return readList(r)
  default: return readAtom(token)
  }
}

func readList(r: Reader, open: String = "(", close: String = ")") -> Form {
  var list = [Form]

  // consume opening "(" token.
  _ = r.next()

  while let token = r.next() {
    if token == close {
      return list
    }

    list.append(readForm(r))
  }
}

func readAtom(token: String) -> Form {
  switch token {
  case atomPattern["comment"]: break
  case atomPattern["nil"]: return .Nil
  case atomPattern["false"]: return .False
  case atomPattern["true"]: return .True
  case atomPattern["integer"]: return .Integer(Integer(token))
  case atomPattern["float"]: return .Float(Float(token))
  case atomPattern["string"]: return .String(token)
  case atomPattern["keyword"]: break
  case atomPattern["symbol"]: return .String(token)

  default: break
  }
}

