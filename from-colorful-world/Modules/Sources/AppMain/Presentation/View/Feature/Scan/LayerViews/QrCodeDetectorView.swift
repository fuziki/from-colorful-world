//
//  QrCodeDetectorView.swift
//
//
//  Created by fuziki on 2021/08/31.
//

import Combine
import Foundation
import SwiftUI

struct QrCodeDetectorView: UIViewRepresentable {
    private let detector: QrCodeDetectorService
    init(flip: AnyPublisher<Void, Never>, detected: PassthroughSubject<String, Never>) {
        detector = DefaultQrCodeDetectorService(flip: flip, detected: detected)
    }

    func makeUIView(context: Context) -> UIView {
        return detector.preview
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
