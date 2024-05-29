//
//  EmailInfoButtonViewController.swift
//  Example
//
//  Created by Mehul Dhorda on 5/8/24.
//

import Bolt
import UIKit

class EmailInfoButtonViewController: UIViewController {
  private lazy var emailTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter your email"
    textField.borderStyle = .roundedRect
    textField.keyboardType = .emailAddress
    textField.autocapitalizationType = .none
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()

  private lazy var emailInfoButton: Bolt.UI.EmailInfoButtonViewController = {
    let button = Bolt.UI.EmailInfoButtonViewController()
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

    view.addSubview(emailTextField)
    add(childViewController: emailInfoButton)

    NSLayoutConstraint.activate([
      emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
      emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      emailInfoButton.view.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
      emailInfoButton.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
    ])
  }
}

extension EmailInfoButtonViewController: BoltEmailInfoButtonViewControllerDelegate {
  func didTapLink(_ sender: Any, url: URL) {
    UIApplication.shared.open(url)
  }
}
