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

// MARK: - Main

var result = ""

tag("table") {
  tag("colgroup") {
    3.times {
      add("<col>")
    }
  }

  tag("tr", content: "emoji")
  tag("tr", content: "alias")
  tag("tr", content: "name")
}

// MARK: - Write

do {
  try result.writeToFile("README.md", atomically: true, encoding: NSUTF8StringEncoding)
} catch {
  print("something goes wrong")
}
