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
  add("## \(content)\n")
}

// MARK: - Main

var result = ""

for (category, list) in emojiCategories {
  header(category)

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

    list.forEach { emoji in
      tag("tr") {
        tag("td", content: emoji)
        tag("td", content: alias(emoji: Character(emoji)) ?? "")
        tag("td", content: name(emoji: Character(emoji)).joinWithSeparator(","))
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
