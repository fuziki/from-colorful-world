//
//  WebViewWrapperView.swift
//
//
//  Created by fuziki on 2021/08/31.
//

import Foundation
import SwiftUI
import WebKit

public struct WebViewWrapperView: UIViewRepresentable {
    private let url: URL
    public init(url: URL) {
        self.url = url
    }

    public func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
