//
//  ViewUtils.swift
//  Example
//
//  Created by Mehul Dhorda on 5/8/24.
//

import SwiftUI
import UIKit

struct NavLink<T: View>: View {
  var view: T
  var title: String

  var body: some View {
      NavigationLink {
          view.navigationTitle(title)
      } label: {
          Text(title)
      }
  }
}

struct UIKitNavLink<T: UIViewController>: View {
  var viewController: T
  var title: String

  var body: some View {
      NavigationLink {
          ViewControllerWrapper(viewController)
              .navigationTitle(title)
              // SwiftUI imposes a safe area for embedded UIKit views
              // Disabling this for checkout sign-in flow to enable loading overlay to fill screen bottom
              .ignoresSafeArea(edges: .bottom)
      } label: {
          Text(title)
      }
  }
}

private struct ViewControllerWrapper<ViewController: UIViewController>: UIViewControllerRepresentable {
  let viewController: ViewController

  init(_ viewController: ViewController) {
    self.viewController = viewController
  }

  func makeUIViewController(context: Context) -> ViewController { viewController }
  func updateUIViewController(_ uiViewController: ViewController, context: Context) { }
}
