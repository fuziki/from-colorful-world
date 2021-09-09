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
    
    @ObservedObject var viewModel: MakeNewQrCodeViewModel
    
    var body: some View {
        ZStack {
            form
            NavigationLink(destination: PrintQrCodeView(title: text,
                                                        qrcodeCount: viewModel.qrcodeCount),
                           isActive: $isActive,
                           label: {
                            EmptyView()
                           })
        }
        .navigationBarTitle(Text("新規2次元コード"), displayMode: .inline)
        .onAppear {
            viewModel.onAppear()
        }
    }

    private var form: some View {
        Form {
            Section(header: Text("新しい2次元コード名を入力"),
                    footer: Text("2次元コード名は1〜10文字で入力してください")) {
                TextField("タップして入力（例）国語ノート", text: $text)
                Stepper("2次元コード数：\(viewModel.qrcodeCount)") {
                    viewModel.increment()
                } onDecrement: {
                    viewModel.decrement()
                }
            }
            .font(.system(size: 16))
            .buttonStyle(PlainButtonStyle())
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
        MakeNewQrCodeView(viewModel: MakeNewQrCodeViewModel(settingService: DefaultSettingService()))
    }
}
