//
//  InAppNoticeViewModel.swift
//
//
//  Created by fuziki on 2021/09/12.
//

import Combine
import Foundation
import SwiftUI

class InAppNoticeViewModel: ObservableObject {
    @Published var offset: CGSize

    private let defaultOffset: CGSize
    private let inAppNoticeService: InAppNoticeService

    private var counter: Int = 0

    private var cancellables: Set<AnyCancellable> = []
    init(inAppNoticeService: InAppNoticeService) {
        let top = UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.top ?? 0
        let offset = CGSize(width: 0, height: -64 - top - 12)
        self.offset = offset
        self.defaultOffset = offset

        self.inAppNoticeService = inAppNoticeService

        self.inAppNoticeService.show.sink { [weak self] _ in
            self?.counter += 1
            let id = self?.counter ?? 0
            self?.offset = self?.defaultOffset ?? .zero
            withAnimation {
                self?.offset = .zero
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                if id != self?.counter { return }
                withAnimation {
                    self?.offset = self?.defaultOffset ?? .zero
                }
            }
        }.store(in: &cancellables)
    }

    public func hide() {
        counter += 1
        withAnimation {
            offset = defaultOffset
        }
    }
}
