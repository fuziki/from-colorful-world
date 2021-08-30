//
//  PdfRenderer.swift
//  
//
//  Created by fuziki on 2021/08/30.
//

import Foundation
import PDFKit

class PdfRenderer {
    struct Entity {
        var paperWidthMillimetre: Double = 297
        var paperHeightMillimetre: Double = 210
        var paddingMillimetre: Double = 10
        var spacingMillimetre: Double = 10
        var horizontallyDivided: Int = 2
        var verticallyDivided: Int = 4
        var dpi: Int = 300
        var fontSize: CGFloat = 74.0
        var titleHeightPx: Int = 300
        var qrTitleSpacerPx: Int = 44
    }
    
    let entity = Entity()
    
    private let cicontext = CIContext(options: [:])
        
    private func makeQRCode(message: String, size: CGFloat) -> CIImage? {
        guard let data = message.data(using: .utf8) else { return nil }
        let params: [String: Any] = ["inputMessage": data,
                                     "inputCorrectionLevel": "L"]
        guard let qrcodeGenerator = CIFilter(name: "CIQRCodeGenerator", parameters: params),
              let outputImage = qrcodeGenerator.outputImage else { return nil }
        let original = outputImage.extent.height
        let sizeTransform = CGAffineTransform(scaleX: size / original, y: size / original)
        return outputImage.transformed(by: sizeTransform)
    }
    
    func makePdfData(title: String) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [
            kCGPDFContextAuthor as String: ""
        ]
        let paperWidth = Int(entity.paperWidthMillimetre / 25.4 * Double(entity.dpi))
        let paperHeight = Int(entity.paperHeightMillimetre / 25.4 * Double(entity.dpi))
        let paperSize = CGSize(width: paperWidth, height: paperHeight)
        let paperRect = CGRect(origin: .zero, size: paperSize)
        let renderer = UIGraphicsPDFRenderer(bounds: paperRect, format: format)
        
        let data = renderer.pdfData { [weak self] (context: UIGraphicsPDFRendererContext) in
            self?.render(context: context, title: title)
        }
        return data
    }
    
    private func render(context: UIGraphicsPDFRendererContext, title: String) {
        let paperSize = context.pdfContextBounds.size
        let padding = CGFloat(Int(entity.paddingMillimetre / 25.4 * Double(entity.dpi)))
        let spacing = CGFloat(Int(entity.spacingMillimetre / 25.4 * Double(entity.dpi)))

        let itemWidth = (paperSize.width - padding * 2 - spacing * CGFloat(entity.verticallyDivided - 1)) / CGFloat(entity.verticallyDivided)
        let itemHeight = (paperSize.height - padding * 2 - spacing * CGFloat(entity.horizontallyDivided - 1)) / CGFloat(entity.horizontallyDivided)
        
        for page in 0..<(40 / (entity.verticallyDivided * entity.horizontallyDivided))+1 {
            context.beginPage()
            for i in 0..<entity.horizontallyDivided {
                for j in 0..<entity.verticallyDivided {
                    let itemX = padding + (itemWidth + spacing) * CGFloat(j)
                    let itemY = padding + (itemHeight + spacing) * CGFloat(i)
                    
                    let qrSize = min(itemWidth, itemHeight - CGFloat(entity.titleHeightPx + entity.qrTitleSpacerPx))
                    let qrX = itemX + itemWidth / 2 - qrSize / 2

                    let titleY = itemY + qrSize + CGFloat(entity.qrTitleSpacerPx)
                    
                    let index = page * entity.horizontallyDivided * entity.verticallyDivided + i * entity.verticallyDivided + j + 1
                    let text = "\(title) - \(index)" as NSString
                    
                    let ci: CIImage = makeQRCode(message: text as String, size: qrSize)!
                    let cgImage = cicontext.createCGImage(ci, from: ci.extent)!
                    context.cgContext.draw(cgImage, in: CGRect(x: qrX, y: itemY, width: qrSize, height: qrSize))
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    let textFont = UIFont.systemFont(ofSize: entity.fontSize, weight: .regular)
                    let textAttributes = [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.font: textFont
                    ]
                    text.draw(in: CGRect(x: itemX, y: titleY, width: itemWidth, height: CGFloat(entity.titleHeightPx)),
                              withAttributes: textAttributes)
                }
            }
        }
    }
}
