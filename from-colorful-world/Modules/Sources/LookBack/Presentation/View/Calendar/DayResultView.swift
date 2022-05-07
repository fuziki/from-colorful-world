//
//  DayResultView.swift
//
//
//  Created by fuziki on 2022/05/07.
//

import Core
import Foundation
import SwiftUI

struct DayResultView: View {
    @ObservedObject private var viewModel: DayResultViewModel
    init(date: Date, classPeaples: Int) {
        let usecase = LookBackUseCase(fileManager: DefaultFileManagerWrapper())
        viewModel = DayResultViewModel(date: date,
                                       calendar: .current,
                                       classPeaples: classPeaples,
                                       usecase: usecase)
    }
    var body: some View {
        ZStack {
            Color.systemGroupedBackground.ignoresSafeArea()
            grid
            if viewModel.isEmpty {
                empty
            }
        }
    }
    // MARK: - Empty State
    private var empty: some View {
        ZStack {
            Color.systemGroupedBackground.ignoresSafeArea()
            Text("保存された結果がありません")
        }
    }

    // MARK: - Grid
    private var grid: some View {
        GeometryReader { proxy in
            HStack(spacing: 1) {
                makeGridView(geometryHeight: proxy.size.height, columns: viewModel.titleColumns)
                ScrollView(.horizontal, showsIndicators: false) {
                    makeGridView(geometryHeight: proxy.size.height, columns: viewModel.resultColumns)
                }
            }
        }
    }
    private func makeGridView(geometryHeight: CGFloat,
                              columns: [[LookBackAssignmentViewGridCellEntity]]) -> some View {
        HStack(spacing: 1) {
            ForEach(columns, id: \.self) { (column: [LookBackAssignmentViewGridCellEntity]) in
                makeColumnView(geometryHeight: geometryHeight, column: column)
            }
        }
    }
    private func makeColumnView(geometryHeight: CGFloat,
                                column: [LookBackAssignmentViewGridCellEntity]) -> some View {
        VStack(spacing: 0) {
            ForEach(column, id: \.self) { (cell: LookBackAssignmentViewGridCellEntity) in
                ZStack {
                    Text(column.first?.text ?? "").opacity(0)
                    Text(cell.text)
                }
                .font(.system(size: geometryHeight / CGFloat(column.count) * 0.7))
                .padding(.vertical, 1)
                .padding(.horizontal, 4)
                .foregroundColor(cell.foregroundColor)
                .background(cell.backgroundColor)
                .background(Color.systemBackground)
                .frame(height: geometryHeight / CGFloat(column.count))
            }
        }
    }
}
