//
//  UsageView.swift
//  
//
//  Created by fuziki on 2021/08/28.
//

import Foundation
import SwiftUI

struct UsageView: View {
    var body: some View {
        WebViewWrapperView(url: URL(string: "https://note.com/shun_same/n/n79835b06b0a9")!)
            .navigationBarTitle(Text("使い方"), displayMode: .inline)
    }
}
