// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {

    public enum MainView {
        public enum Navigate {
            /// Home
            public static let title = L10n.tr("Localizable", "MainView.Navigate.Title")
        }
        public enum Scan {
            /// Scan
            public static let header = L10n.tr("Localizable", "MainView.Scan.Header")
            /// Start Scan
            public static let startScan = L10n.tr("Localizable", "MainView.Scan.StartScan")
        }
    }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = MyBundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}
