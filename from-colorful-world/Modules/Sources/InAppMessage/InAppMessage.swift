//
//  InAppMessage.swift
//
//
//  Created by fuziki on 2022/04/29.
//

import Foundation
import SwiftEntryKit
import UIKit

public protocol InAppMessageService {
    func showLikePush(image: UIImage?, title: String, description: String)
    func showToast(title: String)
}

public class DefaultInAppMessageService: InAppMessageService {
    public init() { }
    public func showLikePush(image: UIImage?, title: String, description: String) {
        DispatchQueue.main.async {
            var attributes = EKAttributes.topFloat
            attributes.entryBackground = .color(color: .standardBackground)
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 3)))
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 4, offset: .zero))
            attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
            attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)

            let title = EKProperty.LabelContent(text: title, style: .init(font: .systemFont(ofSize: 16), color: .standardContent))
            let description = EKProperty.LabelContent(text: description, style: .init(font: .systemFont(ofSize: 14), color: .standardContent))
            let imageContent: EKProperty.ImageContent?
            if let image = image {
                imageContent = .init(image: image, size: CGSize(width: 35, height: 35))
            } else {
                imageContent = nil
            }
            let simpleMessage = EKSimpleMessage(image: imageContent, title: title, description: description)
            let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

            let contentView = EKNotificationMessageView(with: notificationMessage)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    public func showToast(title: String) {
        DispatchQueue.main.async {
            var attributes = EKAttributes.bottomToast
            attributes.entryBackground = .color(color: .init(.gray))

            let title = EKProperty.LabelContent(text: title, style: .init(font: .systemFont(ofSize: 16), color: .white))
            let description = EKProperty.LabelContent(text: "", style: .init(font: .systemFont(ofSize: 14), color: .standardContent))
            let simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
            let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

            let contentView = EKNotificationMessageView(with: notificationMessage)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
}
