//
//  MadeQrCodeListView.swift
//  
//
//  Created by fuziki on 2021/08/28.
//

import Foundation
import SwiftUI

struct MadeQrCodeListView: View {
    var body: some View {
        Form {
            NavigationLink(destination: PrintQrCodeView(title: "こくごノート")) {
                Text("こくごノート")
            }
            .buttonStyle(PlainButtonStyle())
            NavigationLink(destination: PrintQrCodeView(title: "さんすうノート")) {
                Text("さんすうノート")
            }
            .buttonStyle(PlainButtonStyle())
            NavigationLink(destination: PrintQrCodeView(title: "れんらくちょう")) {
                Text("れんらくちょう")
            }
            .buttonStyle(PlainButtonStyle())
            NavigationLink(destination: PrintQrCodeView(title: "ずがこうさくノート")) {
                Text("ずがこうさくノート")
            }
            .buttonStyle(PlainButtonStyle())
        }
        .navigationBarTitle(Text("作成履歴"), displayMode: .inline)
    }
}
