//
//  FormLikeButton.swift
//
//
//  Created by fuziki on 2021/08/30.
//

import AppleExtensions
import Foundation
import SwiftUI

public struct FormLikeButton: View {
    private let systemName: String
    private let title: String
    private let footer: String
    private let action: () -> Void
    public init(systemName: String, title: String, footer: String, action: @escaping () -> Void) {
        self.systemName = systemName
        self.title = title
        self.footer = footer
        self.action = action
    }
    public var body: some View {
        VStack(spacing: 0) {
            Button {
                action()
            } label: {
                HStack {
                    Image(systemName: systemName)
                    Text(title)
                }
                .frame(height: 45)
                .frame(maxWidth: .infinity)
                .background(Color.secondarySystemGroupedBackground)
                .cornerRadius(10)
            }
            Text(footer)
                .multilineTextAlignment(.leading)
                .font(.system(size: 13))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 6)
                .foregroundColor(Color(UIColor.gray))
        }
    }
}
