//
//  UsageView.swift
//  
//
//  Created by fuziki on 2021/08/28.
//

import Foundation
import SwiftUI
import SafariServices

struct UsageView: View {
    let url: URL
    var body: some View {
        WebViewWrapperView(url: url)
            .navigationBarTitle(Text("使い方"), displayMode: .inline)
    }
}
