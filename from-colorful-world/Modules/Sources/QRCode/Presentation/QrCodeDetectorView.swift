//
//  QrCodeDetectorView.swift
//
//
//  Created by fuziki on 2021/08/31.
//

import Combine
import Foundation
import SwiftUI

public struct QrCodeDetectorView: UIViewRepresentable {
    private let detector: QrCodeDetectorService
    public init(flip: AnyPublisher<Void, Never>, detected: PassthroughSubject<String, Never>) {
        detector = DefaultQrCodeDetectorService(flip: flip, detected: detected)
    }

    public func makeUIView(context: Context) -> UIView {
        return detector.preview
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
