//
//  ServiceErrors.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 27/10/20.
//

import Foundation

public enum ServiceError: Error {
    static let parsing = NSError(domain: "parsingError", code: 0, userInfo: nil)
    static let failure = NSError(domain: "failureError", code: 10, userInfo: nil)
}
