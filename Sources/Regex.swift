import Foundation

struct Regex {
  let pattern: String
  let options: NSRegularExpressionOptions!

  private var matcher: NSRegularExpression {
    return try! NSRegularExpression(pattern: pattern, options: options)
  }

  init(pattern: String, options: NSRegularExpressionOptions = nil) {
    self.pattern = pattern
    self.options = options
  }

  func match(s: String, options: NSMatchingOptions = nil) -> Bool {
    let range = NSRange(location: 0, length: s.characters.count)
    return matcher.numberOfMatchesInString(s, options: options, range: range) != 0
  }
}

protocol RegularExpressionMatchable {
  func match(regex: Regex) -> Bool
}

extension String: RegularExpressionMatchable {
  func match(regex: Regex) -> Bool {
    return regex.match(self)
  }
}

func ~=<T: RegularExpressionMatchable>(pattern: Regex, matchable: T) -> Bool {
  return matchable.match(pattern)
}
