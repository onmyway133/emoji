#!/usr/bin/env swift

// xcrun swift -F Carthage/Build/Mac/ script.swift

import Foundation
import Smile

// MARK: - Extension

extension Int {
  func times(@noescape block: () -> Void) {
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

func tag(name: String, @noescape block: () -> Void) {
  add("<\(name)>")
  block()
  add("</\(name)>")
}

func tag(name: String, content: String) {
  add("<\(name)>")
  add(content)
  add("</\(name)>")
}

func header(content: String) {
  add("## \(content)")
}

func title(content: String) {
  add("# \(content)")
}

func br() {
  add("\n")
}

func line(content: String) {
  add(content)
}

// MARK: - Main

title("emoji")
br()
line("- Made with [Smile](https://github.com/onmyway133/Smile)")
br()
line("- Run `xcrun swift -F Carthage/Build/Mac/ script.swift` to update")
br()

let categories = Array(emojiCategories.keys).sort { c1, c2 in
  if c1 == "people" {
    return true
  }

  if c1 == "objects" {
    return true
  }

  return c1 > c2
}

for (category) in categories {
  br()
  header(category)
  br()

  tag("table") {
    tag("colgroup") {
      3.times {
        add("<col>")
      }
    }

    tag("tr") {
      tag("td", content: "emoji")
      tag("td", content: "alias")
      tag("td", content: "name")
    }

    let list = emojiCategories[category]!
    list.forEach { emoji in
      tag("tr") {
        tag("td", content: emoji)
        tag("td", content: alias(emoji: Character(emoji)) ?? "")
        tag("td", content: name(emoji: Character(emoji)).joinWithSeparator(", "))
      }
    }
  }
}

// MARK: - Write

do {
  try result.writeToFile("README.md", atomically: true, encoding: NSUTF8StringEncoding)
} catch {
  print("something goes wrong")
}
