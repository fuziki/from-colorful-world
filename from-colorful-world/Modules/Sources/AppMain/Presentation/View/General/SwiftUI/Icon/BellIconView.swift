//
//  BellIconView.swift
//  
//
//  Created by fuziki on 2021/11/21.
//

import Combine
import Foundation
import SwiftUI

struct BellIconView: View {
    @ObservedObject private var viewModel: BellIconViewModel
    init(showBadge: AnyPublisher<Bool, Never>) {
        viewModel = BellIconViewModel(showBadge: showBadge)
    }
    var body: some View {
        let ui = UIImage(systemName: viewModel.iconName)!
            .withTintColor(.label, renderingMode: .alwaysOriginal)
        Image(uiImage: ui)
    }
}

private class BellIconViewModel: ObservableObject {
    @Published var iconName: String = "bell"
    private let showBadge: AnyPublisher<Bool, Never>
    private var cancellables: Set<AnyCancellable> = []
    init(showBadge: AnyPublisher<Bool, Never>) {
        self.showBadge = showBadge
        self.showBadge
            .receive(on: RunLoop.main)
            .sink { [weak self] showBadge in
                self?.iconName = showBadge ? "bell.badge" : "bell"
            }
            .store(in: &cancellables)
    }
}
