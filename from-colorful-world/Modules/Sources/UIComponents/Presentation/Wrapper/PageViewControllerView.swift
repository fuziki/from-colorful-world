//
//  PageViewControllerView.swift
//
//
//  Created by fuziki on 2022/05/07.
//

import Foundation
import SwiftUI
import UIKit

public struct PageViewControllerView<Page: View, Model: Comparable>: UIViewControllerRepresentable {
    private class ModelHostingController: UIHostingController<Page> {
        internal let model: Model
        init(model: Model, rootView: Page) {
            self.model = model
            super.init(rootView: rootView)
        }

        @MainActor required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    public class Coordinator: NSObject, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
        @Binding private var selection: Model
        private let page: (Model) -> Page
        private let before: (Model) -> Model?
        private let after: (Model) -> Model?
        init(selection: Binding<Model>,
             page: @escaping (Model) -> Page,
             before: @escaping (Model) -> Model?,
             after: @escaping (Model) -> Model?) {
            self._selection = selection
            self.page = page
            self.before = before
            self.after = after
            super.init()
        }

        // MARK: - UIPageViewControllerDelegate
        public func pageViewController(_ pageViewController: UIPageViewController,
                                       didFinishAnimating finished: Bool,
                                       previousViewControllers: [UIViewController],
                                       transitionCompleted completed: Bool) {
            guard let mvc = pageViewController.viewControllers?.first as? ModelHostingController else { return }
            selection = mvc.model
        }

        // MARK: - UIPageViewControllerDataSource
        public func pageViewController(_ pageViewController: UIPageViewController,
                                       viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let mvc = viewController as? ModelHostingController,
                  let model = before(mvc.model) else {
                return nil
            }
            return ModelHostingController(model: model, rootView: page(model))
        }

        public func pageViewController(_ pageViewController: UIPageViewController,
                                       viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let mvc = viewController as? ModelHostingController,
                  let model = after(mvc.model) else {
                return nil
            }
            return ModelHostingController(model: model, rootView: page(model))
        }
    }

    private let navigationOrientation: UIPageViewController.NavigationOrientation
    @Binding private var selection: Model
    private let page: (Model) -> Page
    private let before: (Model) -> Model?
    private let after: (Model) -> Model?
    public init(navigationOrientation: UIPageViewController.NavigationOrientation,
                selection: Binding<Model>,
                page: @escaping (Model) -> Page,
                before: @escaping (Model) -> Model?,
                after: @escaping (Model) -> Model?) {
        self.navigationOrientation = navigationOrientation
        self._selection = selection
        self.page = page
        self.before = before
        self.after = after
    }

    // MARK: - UIViewControllerRepresentable
    public func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selection, page: page, before: before, after: after)
    }

    public typealias UIViewControllerType = UIPageViewController
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: navigationOrientation)
        vc.dataSource = context.coordinator
        vc.delegate = context.coordinator
        let set = ModelHostingController(model: selection, rootView: page(selection))
        vc.setViewControllers([set], direction: .forward, animated: false)
        return vc
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard let mvc = uiViewController.viewControllers?.first as? ModelHostingController,
              mvc.model != selection else {
            return
        }
        let set = ModelHostingController(model: selection, rootView: page(selection))
        let direction: UIPageViewController.NavigationDirection = mvc.model < selection ? .forward : .reverse
        uiViewController.setViewControllers([set], direction: direction, animated: true)
    }
}
