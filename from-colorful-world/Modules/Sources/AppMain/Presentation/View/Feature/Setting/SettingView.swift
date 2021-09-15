//
//  SettingView.swift
//
//
//  Created by fuziki on 2021/09/05.
//

import Foundation
import SwiftUI

struct SettingView: View {
    @ObservedObject private var viewModel = SettingViewModel(settingService: DefaultSettingService())
    var body: some View {
        ZStack {
            form
            versionLabel
        }
        .navigationBarTitle(Text("設定"), displayMode: .inline)
    }
    private var form: some View {
        Form {
            Section(header: Text("スキャンの人数")) {
                Stepper("\(viewModel.classPeaples)人") {
                    viewModel.increment()
                } onDecrement: {
                    viewModel.decrement()
                }
            }
            Section(header: Text("その他")) {
                Picker(selection: $viewModel.feedbackSound, label: Text("効果音")) {
                    ForEach(FeedbackSound.allCases, id: \.self) { (sound: FeedbackSound) in
                        Text(sound.display)
                    }
                }
            }
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
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingView()
        }
    }
}
