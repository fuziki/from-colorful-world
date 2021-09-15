//
//  MadeQrCodeListView.swift
//
//
//  Created by fuziki on 2021/08/28.
//

import Foundation
import SwiftUI

struct MadeQrCodeListView: View {
    let store: MadeQrcodeStoredService
    var body: some View {
        Form {
            if store.list.count > 0 {
                ForEach(store.list.reversed(), id: \.self) { (title) in
                    NavigationLink(destination: PrintQrCodeView(title: title, qrcodeCount: 40)) {
                        Text(title)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Text("作成された2次元コードはありません")
            }
        }
        .navigationBarTitle(Text("作成履歴"), displayMode: .inline)
    }
}
