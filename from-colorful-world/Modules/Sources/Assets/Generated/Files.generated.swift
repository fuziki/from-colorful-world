// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length line_length implicit_return

// MARK: - Files

// swiftlint:disable explicit_type_interface identifier_name
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Files {
  /// Audio/
  public enum Audio {
    /// Audio/SE/
    public enum Se {
      /// fanfare.mp3
      public static let fanfareMp3 = File(name: "fanfare", ext: "mp3", relativePath: "", mimeType: "audio/mpeg")
      /// ohayo.mp3
      public static let ohayoMp3 = File(name: "ohayo", ext: "mp3", relativePath: "", mimeType: "audio/mpeg")
      /// pon.mp3
      public static let ponMp3 = File(name: "pon", ext: "mp3", relativePath: "", mimeType: "audio/mpeg")
      /// recoded.mp3
      public static let recodedMp3 = File(name: "recoded", ext: "mp3", relativePath: "", mimeType: "audio/mpeg")
      /// shutter.mp3
      public static let shutterMp3 = File(name: "shutter", ext: "mp3", relativePath: "", mimeType: "audio/mpeg")
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

public struct File {
  public let name: String
  public let ext: String?
  public let relativePath: String
  public let mimeType: String

  public var url: URL {
    return url(locale: nil)
  }

  public func url(locale: Locale?) -> URL {
    let bundle = MyBundleToken.bundle
    let url = bundle.url(
      forResource: name,
      withExtension: ext,
      subdirectory: relativePath,
      localization: locale?.identifier
    )
    guard let result = url else {
      let file = name + (ext.flatMap { ".\($0)" } ?? "")
      fatalError("Could not locate file named \(file)")
    }
    return result
  }

  public var path: String {
    return path(locale: nil)
  }

  public func path(locale: Locale?) -> String {
    return url(locale: locale).path
  }
}
