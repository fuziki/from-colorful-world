//
//  PdfViewerWrapperView.swift
//
//
//  Created by fuziki on 2021/08/30.
//

import Foundation
import PDFKit
import SwiftUI

public enum PdfViewerWrapperContent {
    case data(Data)
    case url(URL)
}

public struct PdfViewerWrapperView: UIViewRepresentable {
    private let content: PdfViewerWrapperContent
    public init(content: PdfViewerWrapperContent) {
        self.content = content
    }

    public func makeUIView(context: Context) -> PDFView {
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

    public func updateUIView(_ uiView: UIViewType, context: Context) {
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
