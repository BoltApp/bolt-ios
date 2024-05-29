//
//  SignedInStatusButtonViewController.swift
//  Example
//
//  Created by Mehul Dhorda on 5/29/24.
//

import Bolt
import UIKit

class SignedInStatusButtonViewController: UIViewController {
  private lazy var signedInButton: Bolt.UI.SignedInStatusButtonViewController = {
    let button = Bolt.UI.SignedInStatusButtonViewController()
    button.delegate = self
    button.view.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    add(childViewController: signedInButton)

    NSLayoutConstraint.activate([
      signedInButton.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
      signedInButton.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    ])
  }
}

extension SignedInStatusButtonViewController: BoltSignedInStatusButtonViewControllerDelegate {
  func didTapLink(_ sender: Any, url: URL) {
    UIApplication.shared.open(url)
  }
}
