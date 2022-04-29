//
//  PrintQrCodeViewModel.swift
//
//
//  Created by fuziki on 2021/08/31.
//

import Core
import Foundation
import InAppMessage
import PortableDocumentFormat
import SwiftUI

protocol PrintQrCodeViewModelInputs {
    func onAppear()
    func tapShare()
    func tapSave()
}
protocol PrintQrCodeViewModelOutputs {
    var title: String { get }
    var content: PdfViewerWrapperContent? { get }
}
protocol PrintQrCodeViewModelType: ObservableObject {
    var inputs: PrintQrCodeViewModelInputs { get }
    var outputs: PrintQrCodeViewModelOutputs { get }
}
extension PrintQrCodeViewModelType where Self: PrintQrCodeViewModelInputs {
    var inputs: PrintQrCodeViewModelInputs { self }
}
extension PrintQrCodeViewModelType where Self: PrintQrCodeViewModelOutputs {
    var outputs: PrintQrCodeViewModelOutputs { self }
}

class PrintQrCodeViewModel: PrintQrCodeViewModelType,
                            PrintQrCodeViewModelInputs,
                            PrintQrCodeViewModelOutputs {
    public let title: String
    private let qrcodeCount: Int
    private let inAppMessageService: InAppMessageService
    private let fileManagerWrapper: FileManagerWrapper
    private let pdfRenderer: PdfRenderer

    @Published public var content: PdfViewerWrapperContent?

    init(title: String,
         qrcodeCount: Int,
         inAppMessageService: InAppMessageService,
         fileManagerWrapper: FileManagerWrapper,
         pdfRenderer: PdfRenderer) {
        self.title = title
        self.qrcodeCount = qrcodeCount
        self.inAppMessageService = inAppMessageService
        self.fileManagerWrapper = fileManagerWrapper
        self.pdfRenderer = pdfRenderer
    }

    public func onAppear() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            if self.content != nil { return }
            let data = self.pdfRenderer.makePdfData(title: self.title, qrcodeCount: self.qrcodeCount)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                do {
                    let dir = try self.fileManagerWrapper.url(directory: .caches)
                        .appendingPathComponent("hogehoge", isDirectory: true)
                    try self.fileManagerWrapper.createDirectory(at: dir, withIntermediateDirectories: true)
                    let url = dir
                        .appendingPathComponent("\(self.title).pdf")
                    try data.write(to: url)
                    self.content = .url(url)
                } catch let error {
                    print("failed save error: \(error)")
                    self.content = .data(data)
                }
            }
        }
    }

    public func tapShare() {
        guard let content = self.content else { return }
        let activityItems: [Any]
        switch content {
        case .data(let data):
            activityItems = [data]
        case .url(let url):
            activityItems = [url]
        }
        let vc = UIActivityViewController(activityItems: activityItems,
                                          applicationActivities: nil)
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }

        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.popoverPresentationController?.sourceView = rootVC.view
            vc.popoverPresentationController?.sourceRect = CGRect(x: rootVC.view.frame.width / 2,
                                                                  y: 128,
                                                                  width: 1,
                                                                  height: 1)
        }

        DispatchQueue.main.async {
            rootVC.present(vc, animated: true, completion: nil)
        }
    }

    public func tapSave() {
        guard let content = self.content else { return }
        let data: Data
        switch content {
        case .data(let d):
            data = d
        case .url(let url):
            do {
                data = try Data(contentsOf: url)
            } catch let error {
                print("error: \(error), load data from: \(url)")
                return
            }
        }
        do {
            // FIXME: ハードコーディング
            let dir = try fileManagerWrapper.url(directory: .document)
                .appendingPathComponent("2次元コード", isDirectory: true)
            try fileManagerWrapper.createDirectory(at: dir, withIntermediateDirectories: true)
            let file = dir
                .appendingPathComponent("\(title)", conformingTo: .pdf)
            print("\(dir), \(file)")
            try data.write(to: file)
        } catch let error {
            print("error: \(error)")
            return
        }
        inAppMessageService.showLikePush(image: UIImage(systemName: "arrow.down.doc"),
                                         title: "成功！",
                                         description: "ファイルを保存しました")
    }
}
