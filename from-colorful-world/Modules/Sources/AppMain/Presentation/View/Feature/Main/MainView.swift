//
//  MainView.swift
//
//
//  Created by fuziki on 2021/08/28.
//

import Assets
import Combine
import Foundation
import InAppMessage
import LookBack
import SafariServices
import SwiftUI
import UIComponents

public struct MainView: View {
    @ObservedObject private var viewModel: MainViewModel

    public init() {
        viewModel = MainViewModel(usecase: DefaultMainViewUseCase(),
                                  settingService: DefaultSettingService(),
                                  inAppMessageService: DefaultInAppMessageService())
    }

    public var body: some View {
        main
            .preferredColorScheme(nil)
            .onAppear {
                viewModel.onAppear()
            }
            .alert(isPresented: $viewModel.showAlert) {
                alert
            }
            .fullScreenCover(isPresented: $viewModel.scanning) {
            } content: {
                ScanQrCodeView(onComplete: viewModel.onComplete)
                    .preferredColorScheme(.dark)
                    .transition(.identity)
            }
    }

    private var main: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Form {
                        scanSection
                        qrcodeSection
                        miscSection
                    }
                    .navigationBarTitle(Text(Assets.Localization.MainView.Navigate.title),
                                        displayMode: .large)
                    .toolbar {
                        toolbar
                    }
                    bannerView
                        .hidden()
                    infoLink
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }

    private var infoLink: some View {
        let infoViewModel = InfomationViewModel(usecase: DefaultInfomationViewUseCase(),
                                                scheduler: .main)
        let infoView = InfomationView(viewModel: infoViewModel)
        return NavigationLink(destination: infoView,
                              isActive: $viewModel.showInfomation) { }

    }

    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.tapInfomation()
            } label: {
                BellIconView(showBadge: viewModel.showBadge)
            }
        }
    }

    private var scanSection: some View {
        Section(header: Text(Assets.Localization.MainView.Scan.header)) {
            Button {
                print("act!")
                viewModel.startScan()
            } label: {
                NavigationLink(destination: EmptyView(), isActive: .constant(false)) {
                    HStack {
                        Image(systemName: "viewfinder")
                        Text(Assets.Localization.MainView.Scan.startScan)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            NavigationLink(destination: LookBackCalendarView(classPeaples: viewModel.classPeaples)) {
                HStack {
                    Image(systemName: "folder")
                    Text("保存された結果を見る")
                }
            }
        }
    }

    private var alert: Alert {
        let accept: Alert.Button = .default(Text("設定アプリを開く"), action: {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        return Alert(title: Text("カメラの使用を許可してください"),
                     primaryButton: accept,
                     secondaryButton: .cancel(Text("キャンセル")))
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
            Button {
                guard let url = URL(string: AppToken.createQrCodeOnPcPageUrl) else { return }
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
                        Image(systemName: "desktopcomputer")
                        Text("PCで2次元コードを作る")
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
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
            Button {
                guard let url = URL(string: AppToken.usagePageUrl) else { return }
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
