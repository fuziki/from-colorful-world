//
//  PrintQrCodeView.swift
//  
//
//  Created by fuziki on 2021/08/29.
//

import Foundation
import SwiftUI

struct PrintQrCodeView<ViewModelType: PrintQrCodeViewModelType>: View {    
    @ObservedObject private var viewModel: ViewModelType
    
    init(title: String) where ViewModelType == PrintQrCodeViewModel {
        self.init(viewModel: PrintQrCodeViewModel(title: title))
    }
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            share
                .padding(.horizontal, 16)
            pdf
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitle(Text(viewModel.outputs.title), displayMode: .inline)
        .onAppear() {
            viewModel.inputs.onAppear()
        }
    }
    
    private var share: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 18)
            FormLikeButton(systemName: "square.and.arrow.up",
                           title: "シェアする",
                           footer: "「シェアする」をタップすることで、メールなどを使いPDFを送信する事ができます。") {
                viewModel.inputs.tapShare()
            }
            Spacer().frame(height: 18)
            let f2 = "「保存する」をタップすることで、PDFを本体に保存します。\n保存したPDFは「ファイル」アプリを用いて閲覧できます。"
            FormLikeButton(systemName: "arrow.down.doc",
                           title: "保存する",
                           footer: f2) {
                viewModel.inputs.tapSave()
            }
        }
    }
    
    private var pdf: some View {
        Group {
            if viewModel.outputs.content != nil {
                PdfViewerWrapperView(content: viewModel.outputs.content!)
            } else {
                VStack {
                    Spacer().frame(height: 32)
                    Text("PDFを生成中です")
                    Text("この作業は時間がかかる場合があります")
                    Spacer()
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct PrintQrCodeView_Previews: PreviewProvider {
    static var previews: some View {
        PrintQrCodeView(title: "こくごノード")
    }
}
