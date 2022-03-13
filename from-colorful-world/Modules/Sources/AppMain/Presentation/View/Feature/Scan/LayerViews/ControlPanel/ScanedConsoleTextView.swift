//
//  ScanedConsoleTextView.swift
//
//
//  Created by fuziki on 2022/03/13.
//

import Combine
import Foundation
import SwiftUI

struct ScanedConsoleTextView: View {
    @ObservedObject private var viewModel: ScanedConsoleTextViewModel
    init(textPublisher: AnyPublisher<[String], Never>) {
        viewModel = ScanedConsoleTextViewModel(textPublisher: textPublisher)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(viewModel.texts, id: \.self) { (text: String) in
                Text(text)
                    .font(.system(size: 14))
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
    }
}

class ScanedConsoleTextViewModel: ObservableObject {
    @Published var texts: [String] = []
    private var cancellables: Set<AnyCancellable> = []
    init(textPublisher: AnyPublisher<[String], Never>) {
        textPublisher.sink { [weak self] (texts: [String]) in
            self?.texts = texts
        }.store(in: &cancellables)
    }
}
