#!/usr/bin/env swift

// xcrun swift -F Carthage/Build/Mac/ script.swift

import Foundation
import Smile

// MARK: - Extension

extension Int {
  func times(block: () -> Void) {
    for _ in 0..<self {
      block()
    }
  }
}

// MARK: - Helper

var result = ""

func add(string: String) {
  result += string
}

func header(content: String) {
  add(string: "## \(content)")
}

func table(cols: [String]) {
  add(string: cols.joined(separator: " | "))
  br()
  add(string: "---|---|---")
  br()
}

func row(cols: [String]) {
  add(string: cols.joined(separator: " | "))
}

func title(content: String) {
  add(string: "# \(content)")
}

func br() {
  add(string: "\n")
}

func line(content: String) {
  add(string: content)
}

// MARK: - Main

title(content: "emoji")
br()
line(content: "- Made with [Smile](https://github.com/onmyway133/Smile)")
br()
line(content: "- Run `xcrun swift -F Carthage/Build/Mac/ script.swift` to update")
br()

// People first
var categories = Array(emojiCategories.keys)
if let index = categories.index(where: { $0 == "people" }) {
  categories.remove(at: index)
}

categories.insert("people", at: 0)

// Contents
br()
line(content: "## Contents")
br()
br()

// List
for category in categories {
  print(category)
  line(content: "- [\(category)](#\(category))")
  br()
}

for (category) in categories {
  br()
  header(content: category)
  br()

  table(cols: ["emoji", "alias", "name"])

  let list = emojiCategories[category]!
  list.forEach { emoji in
    let maybeAlias = alias(emoji: emoji)

    row(cols: [
      emoji,
      maybeAlias != nil ? "`:\(maybeAlias!):`" : "",
      name(emoji: emoji).joined(separator: ", ")
    ])
    br()
  }
}

// MARK: - Write

do {
  try result.write(toFile: "README.md", atomically: true, encoding: String.Encoding.utf8)
} catch {
  print("something goes wrong")
}
