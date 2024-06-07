//
//  AccountCreationCheckboxView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/13/24.
//

import Bolt
import SwiftUI

struct AccountCreationCheckboxView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Bolt.UI.AccountCheckbox(
        merchantName: "Merchant",
        isChecked: true,
        onCheckboxTap: { isChecked in
          print("isChecked: \(isChecked)")
        },
        onLinkTap: { url in
          UIApplication.shared.open(url)
        }
      )
      Spacer()
    }
    .padding()
  }
}

struct AccountCreationCheckboxView_Previews: PreviewProvider {
  static var previews: some View {
    AccountCreationCheckboxView()
  }
}
