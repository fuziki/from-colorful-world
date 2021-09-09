//
//  MainView.swift
//  
//
//  Created by fuziki on 2021/08/28.
//

import Combine
import Foundation
import SwiftUI

public struct MainView: View {
    @ObservedObject private var viewModel = MainViewModel()
    
    public init() {
        
    }
    
    public var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Form {
                        scanSection
                        qrcodeSection
                        miscSection
                    }
                    .navigationBarTitle(Text("ホーム"), displayMode: .large)
                    versionLabel
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            if viewModel.scanning {
                ScanQrCodeView(onComplete: viewModel.onComplete)
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("カメラの使用を許可してください"),
                  primaryButton: .default(Text("設定アプリを開く"), action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                  }),
                  secondaryButton: .cancel(Text("キャンセル")))
        }
    }
    
    private var versionLabel: some View {
        let appnem = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let versin = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        return Text("\(appnem ?? "app") : \(versin ?? "versin")(\(build ?? "build"))")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .font(.system(size: 14))
            .foregroundColor(.secondary)
    }
    
    private var scanSection: some View {
        Section(header: Text("スキャン")) {
            Button(action: {
                print("act!")
                viewModel.startScan()
            }, label: {
                NavigationLink(destination: EmptyView(), isActive: .constant(false)) {
                    HStack {
                        Image(systemName: "viewfinder")
                        Text("スキャンを開始する")
                    }
                }
                .contentShape(Rectangle())
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var qrcodeSection: some View {
        Section(header: Text("2次元コード")) {
            let viewModel = MakeNewQrCodeViewModel(settingService: DefaultSettingService())
            NavigationLink(destination: MakeNewQrCodeView(viewModel: viewModel)) {
                HStack {
                    Image(systemName: "qrcode")
                    Text("新しい2次元コードを作る")
                }
            }
//            NavigationLink(destination: MadeQrCodeListView(store: DefaultMadeQrcodeStoredService())) {
//                HStack {
//                    Image(systemName: "clock.arrow.circlepath")
//                    Text("コードの作成履歴")
//                }
//            }
        }
    }
    
    private var miscSection: some View {
        Section(header: Text("その他"),
                footer:  Text("使い方を見るためにはインターネット接続が必要です")) {
            NavigationLink(destination: SettingView()) {
                HStack {
                    Image(systemName: "gear")
                    Text("設定")
                }
            }
            Button {
                let url = URL(string: "https://note.com/mori__chan/n/nda0a6c09ee89")!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            } label: {
                NavigationLink(destination: EmptyView()) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("使い方を見る")
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
