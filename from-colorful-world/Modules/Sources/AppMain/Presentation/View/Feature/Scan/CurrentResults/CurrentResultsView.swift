//
//  CurrentResultsView.swift
//  
//
//  Created by fuziki on 2021/08/31.
//

import Combine
import Foundation
import SwiftUI

struct CurrentResultsColumn: Hashable {
    let title: String
    let ok: [Bool]
}

struct CurrentResultsEntity {
    let columns: [CurrentResultsColumn]
    static var `default`: CurrentResultsEntity {
        return CurrentResultsEntity(columns: [])
    }
}

struct CurrentResultsView<ViewModelType: CurrentResultsViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModelType

    init(currentResults: AnyPublisher<CurrentResultsEntity, Never>) where ViewModelType==CurrentResultsViewModel{
        self.init(viewModel: CurrentResultsViewModel(currentResults: currentResults))
    }
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            HStack(spacing: 1) {
                let gridItems = makeGridItems(size: geometry.size.height / CGFloat(viewModel.outputs.rowCount))
                let fontSize = geometry.size.height / CGFloat(viewModel.outputs.rowCount) * 0.7
                makeIndexView(gridItems: gridItems, fontSize: fontSize)
                ScrollView(.horizontal) {
                    makeScanedView(gridItems: gridItems, fontSize: fontSize)
                }
            }
        }
        .padding(.vertical, 16)
    }
    
    private func makeIndexView(gridItems: [GridItem], fontSize: CGFloat) -> some View {
        return LazyHGrid(rows: gridItems) {
            makeTitleView(title: "出席番号", fontSize: fontSize)
            ForEach(1..<viewModel.outputs.rowCount) { i in
                makeOkView(index: i, fontSize: fontSize, ok: false)
            }
        }
    }
    
    private func makeScanedView(gridItems: [GridItem], fontSize: CGFloat) -> some View {
        return LazyHGrid(rows: gridItems, spacing: 1) {
            ForEach(viewModel.outputs.columns, id: \.self) { (column: CurrentResultsColumn) in
                makeTitleView(title: column.title, fontSize: fontSize)
                ForEach(1..<viewModel.outputs.rowCount) { i in
                    makeOkView(index: i, fontSize: fontSize, ok: column.ok[i-1])
                }
            }
        }
    }
    
    private func makeTitleView(title: String, fontSize: CGFloat) -> some View {
        return Text(title)
            .font(.system(size: fontSize))
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func makeOkView(index: Int, fontSize: CGFloat, ok: Bool) -> some View {
        return  Text(ok ? "OK!" : "\(index)")
            .foregroundColor(ok ? .blue.opacity(0.7) : .black)
            .font(.system(size: fontSize))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(index%2==0 ? Color.clear : Color.systemGroupedBackground)
    }
    
    private func makeGridItems(size: CGFloat) -> [GridItem] {
        return (0..<viewModel.outputs.rowCount).map { _ in
            return GridItem(.fixed(size), spacing: 0)
        }
    }
}

struct CurrentResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CurrentResultsView(currentResults: Just<CurrentResultsEntity>(entity).eraseToAnyPublisher())
        }
    }
    static var entity: CurrentResultsEntity {
        return CurrentResultsEntity(columns: [
            CurrentResultsColumn(title: "こくごノート", ok: (1...40).map { $0 % 2 == 0 } ),
            CurrentResultsColumn(title: "さんすうノート", ok: (1...40).map { $0 % 3 < 1 } ),
            CurrentResultsColumn(title: "しゃかいかのけんがくノート", ok: (1...40).map { $0 % 5 < 3 } ),
        ])
    }
}
