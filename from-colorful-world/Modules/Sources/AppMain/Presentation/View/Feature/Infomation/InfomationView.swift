//
//  InfomationView.swift
//
//
//  Created by fuziki on 2021/11/21.
//

import Core
import Combine
import Foundation
import SafariServices
import SwiftUI

struct InfomationViewCellEntity: Hashable {
    let title: String
    let date: String
    let url: URL
}

struct InfomationView<ViewModelType: InfomationViewModelType>: View {
    @ObservedObject var viewModel: ViewModelType

    var body: some View {
        if #available(iOS 15.0, *) {
            shared
                .refreshable { viewModel.inputs.onRefresh() }
        } else {
            shared
        }
    }

    private var shared: some View {
        Form {
            ForEach(viewModel.outputs.cellEntities, id: \.self) { entity in
                makeCell(entity: entity)
            }
        }
        .navigationBarTitle(Text("お知らせ"), displayMode: .inline)
        .onAppear { viewModel.inputs.onAppear() }
    }

    private func makeCell(entity: InfomationViewCellEntity) -> some View {
        Button {
            present(url: entity.url)
        } label: {
            NavigationLink(destination: EmptyView()) {
                VStack(spacing: 8) {
                    Text(entity.title)
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    Text(entity.date)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func present(url: URL) {
        let root = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
        if let r = root {
            let vc = SFSafariViewController(url: url)
            r.present(vc, animated: true, completion: nil)
        } else if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct InfomationView_Previews: PreviewProvider {
    private class MockedInfomationViewModel: InfomationViewModelType,
                                             InfomationViewModelInputs,
                                             InfomationViewModelOutputs {
        let isLoading: Bool = false
        let cellEntities: [InfomationViewCellEntity]
        init(entities: [InfomationViewCellEntity]) {
            self.cellEntities = entities
        }
        func onAppear() { }
        func onRefresh() { }
    }
    static var previews: some View {
        // swiftlint:disable force_unwrapping
        let url = URL(string: "https://example.com/")!
        let entities: [InfomationViewCellEntity] = [
            .init(title: "バージョン1.3.0を公開しました", date: "2021/01/03", url: url),
            .init(title: "バージョン1.2.0を公開しました", date: "2021/01/02", url: url),
            .init(title: "バージョン1.1.0を公開しました", date: "2021/01/01", url: url)
        ]
        let viewModel = MockedInfomationViewModel(entities: entities)
        Group {
            NavigationView {
                InfomationView(viewModel: viewModel)
            }
            .preferredColorScheme(.light)
            NavigationView {
                InfomationView(viewModel: viewModel)
            }
            .preferredColorScheme(.dark)
        }
    }
}
