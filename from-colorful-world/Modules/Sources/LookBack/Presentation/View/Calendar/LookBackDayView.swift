//
//  LookBackDayView.swift
//
//
//  Created by fuziki on 2022/05/04.
//

import Foundation
import SwiftUI
import UIComponents

struct LookBackDayView: View {
    @State var date: Date
    private let classPeaples: Int
    private let formatter = DateFormatter()
    init(date: Date, classPeaples: Int) {
        self._date = State(initialValue: date)
        self.classPeaples = classPeaples
        formatter.setLocalizedDateFormatFromTemplate("MMMdE")
    }
    var body: some View {
        ZStack {
            Color.systemGroupedBackground.ignoresSafeArea()
            pageView
        }
        .navigationBarTitle(Text(formatter.string(from: date)), displayMode: .inline)
        .toolbar { toolbar }
    }

    private var pageView: some View {
        PageViewControllerView(navigationOrientation: .vertical,
                               selection: $date) { (date: Date) -> DayResultView in
            DayResultView(date: date, classPeaples: classPeaples)
        } before: { (date: Date) -> Date? in
            Calendar.current.date(byAdding: .day, value: -1, to: date)
        } after: { (date: Date) -> Date? in
            Calendar.current.date(byAdding: .day, value: 1, to: date)
        }
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                Button {
                    guard let d = Calendar.current.date(byAdding: .day, value: -1, to: date) else { return }
                    date = d
                } label: {
                    Image(systemName: "chevron.up")
                }
                Button {
                    guard let d = Calendar.current.date(byAdding: .day, value: 1, to: date) else { return }
                    date = d
                } label: {
                    Image(systemName: "chevron.down")
                }
            }
        }
    }
}

struct LookBackAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LookBackDayView(date: Date(), classPeaples: 40)
        }
    }
}
