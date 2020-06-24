//
//  AppDelegate.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 22.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()

        let navigationController = UINavigationController()
        window?.rootViewController = navigationController

        let appCoordinator = AppCoordinator(
            navigationController: navigationController,
            context: makeAppContext()
        )
        appCoordinator.start()
        
        return true
    }

    private func makeAppContext() -> AppCoordinator.Context {
        let configuration = AppConfiguration()
        let networkService = NetworkServiceImpl()
        let api = APIImpl(host: configuration.host, networkService: networkService)
        let imageLoader = ImageLoaderImpl(networkService: networkService)
        let imageCache = ImageCacheImpl(
            imageStore: ImageStoreImpl(),
            imageLoader: imageLoader
        )

        return AppCoordinator.Context(api: api, imageLoader: imageLoader, imageCache: imageCache)
    }
}

