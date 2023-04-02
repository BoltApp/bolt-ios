//
//  WebView.swift
//  Example
//
//  Created by Mehul Dhorda on 3/30/23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  let url: URL
  let authCodeReceived: (String) -> Void

  func makeUIView(context: Context) -> WKWebView {
    .init()
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func updateUIView(_ webView: WKWebView, context: Context) {
    webView.navigationDelegate = context.coordinator

    // The call below may show a warning in the console log
    // This is a known issue - https://developer.apple.com/forums/thread/714467
    webView.load(.init(url: url))
  }
}

extension WebView {
  class Coordinator: NSObject, WKNavigationDelegate {
    var parent: WebView

    init(_ parent: WebView) {
      self.parent = parent
    }

    func webView(
      _ webView: WKWebView,
      decidePolicyFor navigationAction: WKNavigationAction,
      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
      guard let urlString = navigationAction.request.url?.absoluteString,
            let url = URL(string: urlString) else {
        assertionFailure("Empty url string")
        return decisionHandler(.allow)
      }

      if urlString.hasPrefix("mobileapp://"), let range = urlString.range(of: "auth_code=") {
        // We have a redirect with auth code in the query parameters
        let index = urlString.distance(from: urlString.startIndex, to: range.upperBound)
        let startIndex = urlString.index(urlString.startIndex, offsetBy: index)
        let authCode = String(urlString[startIndex...])
        decisionHandler(.allow)
        parent.authCodeReceived(authCode)
      } else if urlString == parent.url.absoluteString {
        // This is the original URL request - open as normal
        decisionHandler(.allow)
      } else {
        // Open other links in the system browser, e.g. Terms of Use, Privacy Policy
        UIApplication.shared.open(url)
        decisionHandler(.cancel)
      }
    }
  }
}
