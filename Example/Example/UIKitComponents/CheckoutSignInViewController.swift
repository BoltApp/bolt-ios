//
//  CheckoutSignInViewController.swift
//  Example
//
//  Created by Mehul Dhorda on 5/29/24.
//

import Bolt
import UIKit

class CheckoutSignInViewController: UIViewController {
  private lazy var emailTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter your email"
    textField.borderStyle = .roundedRect
    textField.keyboardType = .emailAddress
    textField.autocapitalizationType = .none
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.userDefaultsKey = "checkoutEmail"
    textField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
    return textField
  }()

  private lazy var signInButton: Bolt.UI.SignInButtonViewController = {
    let button = Bolt.UI.SignInButtonViewController(context: .checkout)
    button.delegate = self
    button.view.isHidden = true
    button.view.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private lazy var continueButton: UIButton = {
    var config = UIButton.Configuration.borderedProminent()
    config.title = "Continue"
    let button = UIButton(configuration: config, primaryAction: .init() { [weak self] _ in
      self?.startAuthorization()
    })
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private lazy var resultLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var stackView: UIStackView = {
    var stackView = UIStackView(arrangedSubviews: [
      emailTextField,
      signInButton.view,
      continueButton,
      resultLabel
    ])
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.spacing = 16
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    addChild(signInButton)
    signInButton.didMove(toParent: self)

    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])

    validateEmail()
  }
}

extension CheckoutSignInViewController: BoltSignInButtonViewControllerDelegate {
  func signInButtonViewControllerDidTapButton(_ controller: Bolt.UI.SignInButtonViewController) {
    startAuthorization()
  }
}

private extension CheckoutSignInViewController {
  func startAuthorization() {
    Bolt.Login.startAuthorization(
      email: emailTextField.text ?? "",
      parentViewController: self,
      context: .checkout,
      onAccountCheck: { [weak self] accountExists in
        self?.signInButton.view.isHidden = !accountExists
      },
      completion: { [weak self] result in
        switch result {
        case .completed(let authorizationCode):
          self?.resultLabel.text = "Received auth code - \(authorizationCode)"
        case .failed(let error):
          self?.resultLabel.text = "Error - \(error.localizedDescription)"
        case .canceled:
          self?.resultLabel.text = "Canceled"
        }
      }
    )
  }

  @objc func emailTextFieldDidChange() {
    validateEmail()
    signInButton.view.isHidden = true
  }

  func validateEmail() {
    continueButton.isEnabled = EmailValidator.isValid(emailTextField.text ?? "")
  }
}
