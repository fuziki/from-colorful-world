//
//  ScanQrCodeControlPanelView.swift
//  
//
//  Created by fuziki on 2021/08/31.
//

import Combine
import Foundation
import SwiftUI

struct ScanQrCodeControlPanelView: View {
    let flip: PassthroughSubject<Void, Never>
    let onComplete: PassthroughSubject<Void, Never>
    let showCurrentResult: PassthroughSubject<Void, Never>
    var body: some View {
        ZStack {
            scaned
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.bottom, 48)
            flipCamera
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            currentResult
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            close
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
    }
    
    private var scaned: some View {
        Text("こくごノート001\nこくごノート001\nこくごノート001\nこく\nごノート0sss01こくごノート001")
            .font(.system(size: 14))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .foregroundColor(.blue)
            .opacity(0.8)
    }
    
    private var flipCamera: some View {
        Button(action: {
            print("flip")
            flip.send(())
        }, label: {
            Text("カメラ変更")
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
        })
        .overlay(Capsule().stroke(lineWidth: 1))
        .background(Capsule().fill(Color.white))
        .foregroundColor(.black)
    }
    
    private var close: some View {
        Button(action: {
            onComplete.send(())
        }, label: {
            Image(systemName: "xmark")
                .font(.system(size: 32, weight: .medium, design: .default))
                .foregroundColor(.black)
                .padding(.horizontal, 4)
                .shadow(radius: 3)
                .shadow(color: .white, radius: 3, x: 0.0, y: 0.0)
        })
    }
    
    private var currentResult: some View {
        Button(action: {
            print("result")
            showCurrentResult.send(())
        }, label: {
            Text("現在の結果")
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
        })
        .overlay(Capsule().stroke(lineWidth: 1))
        .background(Capsule().fill(Color.white))
        .foregroundColor(.black)
    }
}

struct ScanQrCodeControlPanelView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Text("ScanQrCodeView")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .ignoresSafeArea()
            ScanQrCodeControlPanelView(flip: PassthroughSubject<Void, Never>(),
                                       onComplete: PassthroughSubject<Void, Never>(),
                                       showCurrentResult: PassthroughSubject<Void, Never>())
        }
    }
}
