//
//  MyBundleToken.swift
//
//
//  Created by fuziki on 2021/11/13.
//

import Foundation

internal final class MyBundleToken {
    private static let packageName = "Modules"
    private static let bundleName: String = {
        let t = type(of: MyBundleToken())
        let c = NSStringFromClass(t)
        let m = c.components(separatedBy: ".").first!
        return "\(packageName)_\(m)"
    }()
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            let url = Bundle(for: MyBundleToken.self)
                .bundleURL
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent(bundleName + ".bundle")
            return Bundle(url: url)!
        } else {
            return Bundle.module
        }
        #else
        return Bundle(for: MyBundleToken.self)
        #endif
    }()
}
