//
//  LookBackCalendarView.swift
//
//
//  Created by fuziki on 2022/05/02.
//

import Assets
import AppleExtensions
import Core
import Foundation
import SwiftUI

public struct LookBackCalendarView: View {
    @ObservedObject private var viewModel: LookBackCalendarViewModel
    public init(classPeaples: Int) {
        let usecase = LookBackUseCase(fileManager: DefaultFileManagerWrapper())
        viewModel = LookBackCalendarViewModel(date: Date(),
                                              classPeaples: classPeaples,
                                              usecase: usecase)
    }
    public var body: some View {
        ZStack {
            Color.systemGroupedBackground.ignoresSafeArea()
            VStack(spacing: 16) {
                calendar
                showButton
                list
            }
            .padding(.top, 16)
            .frame(maxHeight: .infinity, alignment: .top)
            navigationLink
        }
        .navigationBarTitle(Text("日付"), displayMode: .inline)
        .toolbar { toolbar }
        .onAppear {
            viewModel.onAppear()
        }
    }
    private var calendar: some View {
        DatePicker("", selection: $viewModel.date, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .padding(.horizontal, 8)
            .background(Color.systemBackground.cornerRadius(8))
            .padding(.horizontal, 16)
    }
    private var showButton: some View {
        let opacity = viewModel.disableShowButton ? 0.4 : 1
        return Button {
            viewModel.tapShowButton()
        } label: {
            Text("この日の結果を見る")
                .fontWeight(.bold)
                .foregroundColor(Color.systemBackground)
                .frame(height: 45)
                .frame(maxWidth: .infinity)
        }
        .background(Color.gunjou.opacity(opacity).cornerRadius(10))
        .disabled(viewModel.disableShowButton)
        .padding(.horizontal, 16)
    }
    private var list: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.listTiles, id: \.self) { (title: String) in
                    Text(title)
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                    if viewModel.listTiles.last != title {
                        Divider().padding(.horizontal, 16)
                    }
                }
            }
            .background(Color.secondarySystemGroupedBackground.cornerRadius(8).ignoresSafeArea())
            .padding(.horizontal, 12)
        }
        .padding(.horizontal, 4)
    }
    private var navigationLink: some View {
        NavigationLink(isActive: $viewModel.isActiveNavigationLink) {
            LookBackDayView(date: viewModel.date, classPeaples: viewModel.classPeaples)
        } label: {
            EmptyView()
        }
    }
    @ToolbarContentBuilder private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.date = Date()
            } label: {
                Image(systemName: "calendar")
            }
        }
    }
}

struct LookBackAssignmentListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LookBackCalendarView(classPeaples: 35)
        }
    }
}
