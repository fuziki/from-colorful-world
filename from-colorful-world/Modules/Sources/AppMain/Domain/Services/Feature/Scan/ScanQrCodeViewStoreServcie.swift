//
//  File.swift
//
//
//  Created by fuziki on 2021/09/10.
//

import Foundation

protocol ScanQrCodeViewStoreServcie {
    var isSpeakerMute: Bool { get }
    func update(isSpeakerMute: Bool)
}

class DefaultScanQrCodeViewStoreServcie: ScanQrCodeViewStoreServcie {
    public var isSpeakerMute: Bool

    private let key = "factory.fuziki.from-colorful-world.DefaultScanQrCodeViewStoreServcie.key"
    private let userDefaults: UserDefaultsWrapper = DefaultUserDefaultsWrapper()

    init() {
        isSpeakerMute = userDefaults.fetch(key: key) ?? true
    }

    func update(isSpeakerMute: Bool) {
        self.isSpeakerMute = isSpeakerMute
        self.userDefaults.store(key: key, value: isSpeakerMute)
    }
}
