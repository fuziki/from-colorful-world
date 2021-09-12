//
//  InAppNoticeService.swift
//  
//
//  Created by fuziki on 2021/09/12.
//

import Combine
import Foundation

class InAppNoticeService {
    static var shared = InAppNoticeService()
    var show = PassthroughSubject<String, Never>()
    private init() { }
}
