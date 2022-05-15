//
//  MakeNewQrCodeView.swift
//
//
//  Created by fuziki on 2021/08/28.
//

import Assets
import Foundation
import Setting
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
    }

    private var form: some View {
        Form {
            Section(header: Text("提出物名を入力（必須）"),
                    footer: Text("提出物名は1〜10文字で入力してください\n（例）国語ファイル")) {
                TextField("ここをタップして入力", text: $text)
                    .font(.system(size: 16))
                Stepper("2次元コード数：\(viewModel.qrcodeCount)") {
                    viewModel.increment()
                } onDecrement: {
                    viewModel.decrement()
                }
                .font(.system(size: 16))
            }
            .buttonStyle(PlainButtonStyle())
            Section(footer: makeButtonFooter) {
                makeButton
                    .buttonStyle(PlainButtonStyle())
                    .contentShape(Rectangle())
                    .foregroundColor(.blue)
                    .disabled(text.count <= 0 || text.count > 10)
            }
        }
    }

    private var makeButtonFooter: some View {
        Group {
            if text.count == 0 {
                Text("提出物名を入力してください")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private var makeButton: some View {
        Button {
            print("make!")
            if text.count == 0 { return }
            isActive = true
        } label: {
            HStack {
                Spacer()
                Text("2次元コードを作成する")
                    .fontWeight(.bold)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .foregroundColor(.systemBackground)
        .listRowBackground(Color.gunjou.opacity(text.count == 0 ? 0.4 : 1))
    }
}

struct MakeNewQrCodeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            makeView(text: "こくご")
                .colorScheme(.light)
            makeView(text: "さんすうノート")
                .colorScheme(.dark)
            makeView(text: "")
                .colorScheme(.light)
            makeView(text: "")
                .colorScheme(.dark)
        }
    }
    static func makeView(text: String) -> some View {
        let vm = MakeNewQrCodeViewModel(settingService: DefaultSettingService.shared)
        let v = MakeNewQrCodeView(text: text, viewModel: vm)
        return v
    }
}
