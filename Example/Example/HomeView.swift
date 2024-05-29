//
//  HomeView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/19/23.
//

import Bolt
import SwiftUI

struct HomeView: View {
  @AppStorage("publishableKey") var publishableKey = ""
  @AppStorage("environment") var environment = Bolt.Environment.sandbox

  init() {
    Bolt.ClientProperties.shared.environment = environment
    Bolt.ClientProperties.shared.publishableKey = publishableKey
  }
  
  var body: some View {
    NavigationView {
      List {
        NavLink(view: SwiftUIComponentsView(), title: "SwiftUI components")
        NavLink(view: UIKitComponentsView(), title: "UIKit components")
        NavLink(view: TokenizerView(), title: "Credit card tokenizer")
        NavLink(view: AnalyticsView(), title: "Analytics")
        Spacer()
        Text("Settings:")
        HStack {
          Text("Environment")
          Picker("Options", selection: $environment) {
            Text("Sandbox").tag(Bolt.Environment.sandbox)
            Text("Production").tag(Bolt.Environment.production)
          }
          .pickerStyle(.segmented)
          .onChange(of: environment) { newValue in
            Bolt.ClientProperties.shared.environment = environment
          }
        }
        VStack {
          TextField("Publishable key", text: $publishableKey)
            .onChange(of: publishableKey) { newValue in
              Bolt.ClientProperties.shared.publishableKey = newValue
            }
          .textFieldStyle(RoundedBorderTextFieldStyle())
        }
      }
      .listStyle(.plain)
      .navigationTitle("Bolt iOS Example")
      .padding([.top])
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
