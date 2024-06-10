//
//  EmailValidator.swift
//  Bolt SDK Example
//
//  Created by Mehul Dhorda on 6/10/24.
//

import Foundation

struct EmailValidator {
  static let emailRegex = "^[a-zA-Z0-9\"_.+-]*[^.@]@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]*[a-zA-Z]$"

  /// Simple email validator.
  static func isValid(_ email: String) -> Bool {
    email.range(of: emailRegex, options: .regularExpression) != nil
  }
}
