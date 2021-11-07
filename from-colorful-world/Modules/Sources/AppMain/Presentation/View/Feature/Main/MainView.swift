//
//  MainView.swift
//
//
//  Created by fuziki on 2021/08/28.
//

import Assets
import Combine
import Foundation
import SwiftUI
import SafariServices

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
                    .navigationBarTitle(Text(HandMadeStrings.mainViewNavigateTitle), displayMode: .large)
                    bannerView
                        .hidden()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            if viewModel.scanning {
                ScanQrCodeView(onComplete: viewModel.onComplete)
            }
            InAppNoticeView()
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

    private var scanSection: some View {
        Section(header: Text(HandMadeStrings.mainViewScanHeader)) {
            Button(action: {
                print("act!")
                viewModel.startScan()
            }, label: {
                NavigationLink(destination: EmptyView(), isActive: .constant(false)) {
                    HStack {
                        Image(systemName: "viewfinder")
                        Text(HandMadeStrings.mainViewScanStartScan)
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
        }
    }

    private var miscSection: some View {
        Section(header: Text("その他"),
                footer: Text("使い方を見るためにはインターネット接続が必要です")) {
            NavigationLink(destination: SettingView()) {
                HStack {
                    Image(systemName: "gear")
                    Text("設定")
                }
            }
            let url = URL(string: "https://note.com/mori__chan/n/nda0a6c09ee89")!
            //            NavigationLink(destination: UsageView(url: url)) {
            //                HStack {
            //                    Image(systemName: "info.circle")
            //                    Text("使い方を見る")
            //                }
            //            }
            Button {
                let root = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
                if let r = root {
                    let vc = SFSafariViewController(url: url)
                    r.present(vc, animated: true, completion: nil)
                } else if UIApplication.shared.canOpenURL(url) {
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
            //            Button {
            //                if UIApplication.shared.canOpenURL(url) {
            //                    UIApplication.shared.open(url)
            //                }
            //            } label: {
            //                NavigationLink(destination: EmptyView()) {
            //                    HStack {
            //                        Image(systemName: "info.circle")
            //                        Text("使い方を見る")
            //                    }
            //                }
            //                .contentShape(Rectangle())
            //            }
            //            .buttonStyle(PlainButtonStyle())
        }
    }

    private var bannerView: some View {
        BannerAdView()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
