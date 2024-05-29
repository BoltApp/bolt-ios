//
//  AccountCreationCheckboxViewController.swift
//  Example
//
//  Created by Mehul Dhorda on 5/29/24.
//

import Bolt
import UIKit

class AccountCreationCheckboxViewController: UIViewController {
  private lazy var accountCheckbox: Bolt.UI.AccountCheckboxViewController = {
    let accountCheckbox = Bolt.UI.AccountCheckboxViewController(
      merchantName: "Merchant name",
      isChecked: true
    )
    accountCheckbox.delegate = self
    accountCheckbox.view.translatesAutoresizingMaskIntoConstraints = false
    return accountCheckbox
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    add(childViewController: accountCheckbox)

    NSLayoutConstraint.activate([
      accountCheckbox.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
      accountCheckbox.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      accountCheckbox.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      // TODO: fix issue with requiring bottom constraint
      accountCheckbox.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
    ])
  }
}

extension AccountCreationCheckboxViewController: BoltAccountCheckboxViewControllerDelegate {
  func didTapLink(_ sender: Any, url: URL) {
    UIApplication.shared.open(url)
  }

  func accountCheckboxViewController(
    _ controller: Bolt.UI.AccountCheckboxViewController,
    didChangeToggle isChecked: Bool
  ) {
    print("isChecked: \(isChecked)")
  }
}
