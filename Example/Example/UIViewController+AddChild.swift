//
//  UIViewController+AddChild.swift
//  Example
//
//  Created by Mehul Dhorda on 5/29/24.
//

import UIKit

extension UIViewController {
  func add(childViewController: UIViewController) {
    addChild(childViewController)
    view.addSubview(childViewController.view)
    childViewController.didMove(toParent: self)
  }
}
