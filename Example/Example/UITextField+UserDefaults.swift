//
//  UITextField+UserDefaults.swift
//  Example
//
//  Created by Mehul Dhorda on 5/29/24.
//

import UIKit
import ObjectiveC

private var keyHandle: UInt8 = 0

extension UITextField {
  /// Set key to load/save text using user defaults.
  var userDefaultsKey: String? {
    get {
      return objc_getAssociatedObject(self, &keyHandle) as? String
    }
    set {
      objc_setAssociatedObject(self, &keyHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      loadText()
      setupObservers()
    }
  }

  private func loadText() {
    if let key = userDefaultsKey {
      text = UserDefaults.standard.string(forKey: key)
    }
  }

  private func setupObservers() {
    addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
  }

  @objc private func textFieldDidChange() {
    if let key = userDefaultsKey, let text = text {
      UserDefaults.standard.set(text, forKey: key)
    }
  }
}
