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
        Form {
            Section(header: Text("クラスの人数")) {
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
        .navigationBarTitle(Text("設定"), displayMode: .inline)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingView()
        }
    }
}
