//
//  CreateAccountView.swift
//  Example
//
//  Created by Mehul Dhorda on 4/8/23.
//

import SwiftUI

struct CreateAccountView: View {
  @State private var isChecked = true

  private enum Layout {
    static let verticalPadding: CGFloat = 4
    static let horizontalPadding: CGFloat = 12
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        HStack(spacing: Layout.horizontalPadding) {
          Image(isChecked ? "Checkbox checked" : "Checkbox unchecked")
          CreateBoltAccountView()
        }
        .onTapGesture {
          isChecked.toggle()
        }

        Text(disclaimerText)
          .font(.caption)
          .padding([.top], Layout.verticalPadding)
          .padding([.leading])
          .padding([.leading], Layout.horizontalPadding)

        Spacer()
      }
      .padding()
    }
  }

  private var disclaimerText: AttributedString = {
    let text = "By checking above, you agree to Bolt's __[terms](https://www.bolt.com/end-user-terms)__ and __[privacy policy](https://www.bolt.com/privacy)__."

    guard var attrString = try? AttributedString(markdown: text) else {
      return .init()
    }

    let linkColor = Color(red: 96 / 255, green: 96 / 255, blue: 96 / 255)
    let links = ["terms", "privacy policy"]
    links.forEach {
      guard let range = attrString.range(of: $0) else { return }
      attrString[range].foregroundColor = linkColor
      attrString[range].underlineStyle = .single
    }

    return attrString
  }()
}

/// View that embeds Bolt logo inside account creation text
private struct CreateBoltAccountView: View {
  @State private var fittingSize: CGSize = .zero

  private enum Constants {
    static let logoToken = "<boltlogo>"
    static let text = "Save my info with \(logoToken) for faster checkout."
    static let logoImage = UIImage(named: "Bolt logo")
  }

  var body: some View {
    CreateBoltAccountText(fittingSize: $fittingSize)
      .frame(minHeight: fittingSize.height)
  }

  private struct CreateBoltAccountText: UIViewRepresentable {
    @Binding var fittingSize: CGSize

    func makeUIView(context: Context) -> UILabel {
      let label = UILabel()

      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping

      // Prevent label from expanding past available width
      label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

      return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
      let attributedText = NSMutableAttributedString(string: Constants.text)
      attributedText.replace(string: Constants.logoToken, with: Constants.logoImage)
      uiView.attributedText = attributedText

      DispatchQueue.main.async {
        // Calculate size required to fit label within container bounds
        let containerSize = uiView.superview?.bounds.size
        fittingSize = uiView.sizeThatFits(containerSize ?? .zero)
      }
    }
  }
}

private extension NSMutableAttributedString {
  /// Replace string token with inline image
  func replace(string: String, with image: UIImage?) {
    let range = mutableString.range(of: string)
    guard let image, range.length > 0 else { return }

    let logoAttrString = NSMutableAttributedString()
    logoAttrString.append([.spacer, .image(image), .spacer])

    replaceCharacters(in: range, with: logoAttrString)
  }

  /// Append an array of attributed strings
  func append(_ strings: [NSAttributedString]) {
    strings.forEach(append)
  }
}

private extension NSAttributedString {
  /// Create attributed string with image
  static func image(_ image: UIImage) -> NSAttributedString {
    let imageScale = 1.5
    let imageSize = CGSize(
      width: image.size.width * imageScale,
      height: image.size.height * imageScale
    )

    // Vertically center image with text
    let font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
    let yOffset = (font.capHeight - imageSize.height) / 2

    let imageAttachment = NSTextAttachment()
    imageAttachment.image = image
    imageAttachment.bounds = CGRect(origin: .zero, size: imageSize)
    imageAttachment.bounds.origin.y = yOffset

    return .init(attachment: imageAttachment)
  }

  /// Create attributed string for spacer used between image and text
  static var spacer: NSAttributedString {
    let spacerSize = CGSize(width: 4, height: 0)
    let spacerAttachment = NSTextAttachment()
    spacerAttachment.bounds = .init(origin: .zero, size: spacerSize)

    return .init(attachment: spacerAttachment)
  }
}

struct CreateAccountView_Previews: PreviewProvider {
  static var previews: some View {
    CreateAccountView()
  }
}
