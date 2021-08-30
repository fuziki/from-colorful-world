//
//  MakeNewQrCodeView.swift
//  
//
//  Created by fuziki on 2021/08/28.
//

import Foundation
import SwiftUI

struct MakeNewQrCodeView: View {
    @State var text: String = ""
    
    @State var isActive: Bool = false
    var body: some View {
        VStack {
            form
            NavigationLink(destination: PrintQrCodeView(title: text),
                           isActive: $isActive,
                           label: {
                            EmptyView()
                           })
        }
        .onTapGesture {
            UIApplication.shared
                .sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationBarTitle(Text("新規2次元コード"), displayMode: .inline)
    }
    
    private var form: some View {
        Form {
            Section(header: Text("新しい2次元コード名を入力"),
                    footer: Text("2次元コード名は20文字まで入力する事が可能です")) {
                TextField("ここをタップして入力", text: $text)
            }
            Section {
                makeButton
                    .buttonStyle(PlainButtonStyle())
                    .contentShape(Rectangle())
                    .foregroundColor(.blue)
            }
        }
    }

    private var makeButton: some View {
        Button(action: {
            print("make!")
            if text.count == 0 { return }
            isActive = true
        }, label: {
            HStack {
                Spacer()
                Text("2次元コードを作成する")
                Spacer()
            }
            .contentShape(Rectangle())
        })
    }
}

struct MakeNewQrCodeView_Previews: PreviewProvider {
    static var previews: some View {
        MakeNewQrCodeView()
    }
}
