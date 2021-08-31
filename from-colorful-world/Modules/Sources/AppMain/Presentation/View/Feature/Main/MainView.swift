//
//  MainView.swift
//  
//
//  Created by fuziki on 2021/08/28.
//

import Foundation
import SwiftUI

public struct MainView: View {
    @State var scanning: Bool = false
    
    public init() {
        
    }
    
    public var body: some View {
        ZStack {
            NavigationView {
                Form {
                    scanSection
                    qrcodeSection
                    miscSection
                }
                .navigationBarTitle(Text("ホーム"), displayMode: .large)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            if scanning {
                ScanQrCodeView()
            }
        }
    }
    
    private var scanSection: some View {
        Section(header: Text("スキャン")) {
            Button(action: {
                print("act!")
                scanning = true
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
            NavigationLink(destination: MakeNewQrCodeView()) {
                HStack {
                    Image(systemName: "qrcode")
                    Text("新しい2次元コードを作る")
                }
            }
            NavigationLink(destination: MadeQrCodeListView()) {
                HStack {
                    Image(systemName: "list.dash")
                    Text("コードの作成履歴を確認する")
                }
            }
        }
    }
    
    private var miscSection: some View {
        Section(header: Text("その他"),
                footer:  Text("使い方を見るためにはインターネット接続が必要です")) {
            NavigationLink(destination: UsageView()) {
                HStack {
                    Image(systemName: "info.circle")
                    Text("使い方を見る")
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
