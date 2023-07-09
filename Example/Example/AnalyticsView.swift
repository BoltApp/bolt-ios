//
//  AnalyticsView.swift
//  Example
//
//  Created by Mehul Dhorda on 7/5/23.
//

import Bolt
import SwiftUI

struct AnalyticsView: View {

  @State private var showingAlert = false

  init() {
    // Set common properties that are included in all analytics
    Bolt.Analytics.setCommonProperties(
      [
        "boolean": true,
        "number": 123,
        "array": ["1", "2", "3"],
        "dictionary": [ "key": "val" ]
      ]
    )
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Button("Send analytics event") {
          // Sends an analytics event with an additional custom property
          Bolt.Analytics.log(.paymentSuccessful, ["additional": "value"])
          showingAlert = true
        }
        .alert(isPresented: $showingAlert) {
          Alert(title: Text("Event was sent"))
        }
        Spacer()
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .navigationTitle("Analytics")
  }
}

struct AnalyticsView_Previews: PreviewProvider {
  static var previews: some View {
    AnalyticsView()
  }
}
