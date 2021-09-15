//
//  WebViewWrapperView.swift
//
//
//  Created by fuziki on 2021/08/31.
//

import Foundation
import SwiftUI
import WebKit

struct WebViewWrapperView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
