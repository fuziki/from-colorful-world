//
//  CurrentResultsRootView.swift
//
//
//  Created by fuziki on 2021/08/31.
//

import Combine
import Foundation
import SwiftUI

struct CurrentResultsRootView: View {
    @ObservedObject private var viewModel: CurrentResultsRootViewModel
    init(currentResults: AnyPublisher<CurrentResultsEntity, Never>, showCurrentResults: AnyPublisher<Void, Never>) {
        viewModel = CurrentResultsRootViewModel(currentResults: currentResults, showCurrentResults: showCurrentResults)
    }
    var body: some View {
        Color.clear
            .sheet(isPresented: $viewModel.show) {
                CurrentResultsView(currentResults: viewModel.currentResults)
            }
    }
}
