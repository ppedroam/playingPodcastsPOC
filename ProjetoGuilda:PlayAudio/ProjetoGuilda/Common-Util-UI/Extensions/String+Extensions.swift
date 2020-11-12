//
//  String+Extensions.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 27/10/20.
//

import Foundation

extension String {
    func replace(occurences: [String], with string: String) -> String {
        var newString = self
        for occur in occurences {
            newString = newString.replacingOccurrences(of: occur, with: string)
        }
        return newString
    }
}
