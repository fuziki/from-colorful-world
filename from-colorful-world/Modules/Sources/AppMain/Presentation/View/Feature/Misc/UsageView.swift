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
        WebViewWrapperView(url: URL(string: "https://note.com/mori__chan/n/nda0a6c09ee89")!)
            .navigationBarTitle(Text("使い方"), displayMode: .inline)
    }
}
