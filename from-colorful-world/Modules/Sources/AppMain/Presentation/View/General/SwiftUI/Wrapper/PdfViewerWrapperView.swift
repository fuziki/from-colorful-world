//
//  PdfViewerWrapperView.swift
//
//
//  Created by fuziki on 2021/08/30.
//

import Foundation
import PDFKit
import SwiftUI

enum PdfViewerWrapperContent {
    case data(Data)
    case url(URL)
}

struct PdfViewerWrapperView: UIViewRepresentable {
    let content: PdfViewerWrapperContent

    func makeUIView(context: Context) -> PDFView {
        let pdfDocument: PDFDocument?
        switch content {
        case .data(let data):
            pdfDocument = PDFDocument(data: data)
        case .url(let url):
            pdfDocument = PDFDocument(url: url)
        }
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        return pdfView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        let pdfDocument: PDFDocument?
        switch content {
        case .data(let data):
            pdfDocument = PDFDocument(data: data)
        case .url(let url):
            pdfDocument = PDFDocument(url: url)
        }
        uiView.document = pdfDocument
    }
}
