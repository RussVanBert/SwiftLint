//
//  EmptyLineWhitespaceRule.swift
//  SwiftLint
//
//  Created by Russell Van Bert on 20/05/2015.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import SourceKittenFramework

struct EmptyLineWhitespaceRule: Rule {
    let identifier = "emptyLine_whitespace"
    let parameters = [RuleParameter<Void>]()
    
    func validateFile(file: File) -> [StyleViolation] {
        return file.contents.lines().map { line in
            (
                index: line.index,
                trailingWhitespaceCount: line.content.countOfTailingCharactersInSet(
                    NSCharacterSet.whitespaceCharacterSet()
                ),
                onlyWhitespace: line.content.only(
                    NSCharacterSet.whitespaceCharacterSet()
                )
            )
        }.filter {
            $0.trailingWhitespaceCount > 0 && $0.onlyWhitespace
        }.map {
            StyleViolation(type: .EmptyLineWhitespace,
                location: Location(file: file.path, line: $0.index),
                severity: .Medium,
                reason: "Line #\($0.index) is a blank line containing whitespace: " +
                "currently has \($0.trailingWhitespaceCount) whitespace characters")
        }
    }
}
