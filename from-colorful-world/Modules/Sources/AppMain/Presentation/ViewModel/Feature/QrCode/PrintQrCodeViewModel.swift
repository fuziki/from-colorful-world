//
//  PrintQrCodeViewModel.swift
//  
//
//  Created by fuziki on 2021/08/31.
//

import Foundation
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
    private let inAppNoticeService: InAppNoticeService
    
    @Published public var content: PdfViewerWrapperContent?
    
    init(title: String,
         qrcodeCount: Int,
         inAppNoticeService: InAppNoticeService) {
        self.title = title
        self.qrcodeCount = qrcodeCount
        self.inAppNoticeService = inAppNoticeService
    }
    
    public func onAppear() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.content != nil { return }
            let data = PdfRenderer().makePdfData(title: self.title, qrcodeCount: self.qrcodeCount)
            self.content = .data(data)
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
        let rootVC = UIApplication.shared.windows.first!.rootViewController!
        
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
        case .url(_):
           return
        }
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dir = docPath
            // FIXME: ハードコーディング
            .appendingPathComponent("2次元コード", isDirectory: true)
        // TODO: Mock
        try! FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
        let file = dir
            .appendingPathComponent("\(title)", conformingTo: .pdf)
        print("\(docPath), \(file)")
        do {
            try data.write(to: file)
        } catch let error {
            print("error: \(error)")
            return
        }
        inAppNoticeService.show.send("ファイルを保存しました！")
    }
}
