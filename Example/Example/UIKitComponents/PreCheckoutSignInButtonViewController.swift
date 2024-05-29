//
//  PreCheckoutSignInButtonViewController.swift
//  Example
//
//  Created by Mehul Dhorda on 5/29/24.
//

import Bolt
import UIKit

class PreCheckoutSignInButtonViewController: UIViewController {
  private lazy var emailTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter your email"
    textField.borderStyle = .roundedRect
    textField.keyboardType = .emailAddress
    textField.autocapitalizationType = .none
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.userDefaultsKey = "preCheckoutEmail"
    return textField
  }()

  private lazy var signInButton: Bolt.UI.SignInButtonViewController = {
    let button = Bolt.UI.SignInButtonViewController(context: .preCheckout)
    button.delegate = self
    button.view.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private lazy var resultLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
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
    view.addSubview(resultLabel)
    add(childViewController: signInButton)

    NSLayoutConstraint.activate([
      emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
      emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      signInButton.view.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
      signInButton.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),

      resultLabel.topAnchor.constraint(equalTo: signInButton.view.bottomAnchor, constant: 16),
      resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
    ])
  }
}

extension PreCheckoutSignInButtonViewController: BoltSignInButtonViewControllerDelegate {
  func signInButtonViewControllerDidTapButton(_ controller: Bolt.UI.SignInButtonViewController) {
    Bolt.Login.startAuthorization(
      email: emailTextField.text ?? "",
      parentViewController: self,
      context: .preCheckout
    ) { [weak self] result in
      switch result {
      case .completed(let authorizationCode):
        self?.resultLabel.text = "Received auth code - \(authorizationCode)"
      case .failed(let error):
        self?.resultLabel.text = "Error - \(error.localizedDescription)"
      case .canceled:
        self?.resultLabel.text = "Canceled"
      }
    }
  }
}
