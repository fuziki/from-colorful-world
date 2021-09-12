//
//  InAppNoticeView.swift
//  
//
//  Created by fuziki on 2021/09/12.
//

import Combine
import Foundation
import SwiftUI

struct InAppNoticeView: View {
    @ObservedObject var viewModel = InAppNoticeViewModel(inAppNoticeService:  InAppNoticeService.shared)
    
    @State var gestureOffset: CGSize = .zero
    
    let height: CGFloat = 80
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.systemBackground)
                .shadow(color: .black.opacity(0.4), radius: 4, x: 0.0, y: 0.0)
            HStack {
                Image(systemName: "arrow.down.doc")
                    .font(.system(size: 20))
                Text("ファイルを保存しました！")
                    .font(.system(size: 18))
            }
        }
        .opacity(viewModel.offset.height < 0 ? 0 : 1)
        .padding(.horizontal, 8)
        .frame(height: height)
        .offset(viewModel.offset)
        .offset(gestureOffset)
        .gesture(gesture)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    var gesture: some Gesture {
        DragGesture()
            .onChanged { (value: DragGesture.Value) in
                let height = min(value.translation.height, height / 2)
                gestureOffset = CGSize(width: 0, height: height)
            }
            .onEnded { (value: DragGesture.Value) in
                if value.translation.height < (height / -2) {
                    viewModel.hide()
                }
                withAnimation {
                    gestureOffset = .zero
                }
            }
    }
}

struct InAppNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color
                .systemGroupedBackground
                .ignoresSafeArea()
            InAppNoticeView()
        }
    }
}
