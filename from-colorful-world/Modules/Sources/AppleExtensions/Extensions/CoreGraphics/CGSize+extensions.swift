//
//  CGSize+extensions.swift
//
//
//  Created by fuziki on 2022/04/24.
//

import CoreGraphics
import Foundation

extension CGSize {
    public static func * (size: CGSize, scale: CGFloat) -> CGSize {
        return CGSize(width: size.width * scale, height: size.height * scale)
    }
}
