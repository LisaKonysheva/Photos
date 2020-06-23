//
//  AppCoordinator.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 22.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import UIKit

struct AppCoordinator {
    private let navigationController: UINavigationController
    private let context: Context

    struct Context {
        let api: API
        let imageLoader: ImageLoader
        let imageCache: ImageCache
    }

    init(
        navigationController: UINavigationController,
        context: Context
    ){
        self.navigationController = navigationController
        self.context = context
    }

    func start() {
        let viewController = PhotosListViewController()

        let handlers = PhotosList.Handlers {
            self.openPhoto(with: $0)
        }
        let viewModel = PhotosList.ViewModel(
            context: PhotosList.Context(
                api: context.api,
                imageCache: context.imageCache),
            handlers: handlers
        )

        viewController.viewModel = viewModel
        navigationController.setViewControllers([viewController], animated: false)
    }

    private func openPhoto(with id: Int) {
        let viewController = PhotoDetailsViewController()
        let viewModel = PhotoDetails.ViewModel(
            context: PhotoDetails.Context(
                api: context.api,
                imageLoader: context.imageLoader),
            photoId: id
        )
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
