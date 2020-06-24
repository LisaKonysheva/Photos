//
//  ImageCache.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 23.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import UIKit

protocol ImageStore {
    func image(forUrl url: NSURL) -> UIImage?
    func set(image: UIImage, forKey key: NSURL)
}

final class ImageStoreImpl: ImageStore {
    private let cache = NSCache<NSURL, UIImage>()

    func image(forUrl url: NSURL) -> UIImage? {
        cache.object(forKey: url)
    }

    func set(image: UIImage, forKey key: NSURL) {
        cache.setObject(image, forKey: key)
    }
}

protocol ImageCache {
    func load(url: URL, completion: @escaping (UIImage?) -> Void)
}

final class ImageCacheImpl: ImageCache {
    private let imageStore: ImageStore
    private var completions = [NSURL: [(UIImage?) -> Void]]()
    private let imageLoader: ImageLoader

    init(
        imageStore: ImageStore,
        imageLoader: ImageLoader
    ) {
        self.imageLoader = imageLoader
        self.imageStore = imageStore
    }

    func load(url: URL, completion: @escaping (UIImage?) -> Void) {
        let urlKey = url as NSURL
        if let cachedImage = imageStore.image(forUrl: urlKey) {
            completion(cachedImage)
            return
        }

        if completions[urlKey] != nil {
            completions[urlKey]?.append(completion)
        } else {
            completions[urlKey] = [completion]
        }

        imageLoader.loadImage(from: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.imageStore.set(image: image, forKey: urlKey)
                self?.completions[urlKey]?.forEach { $0(image) }
            case .failure:
                self?.completions[urlKey]?.forEach { $0(nil) }
            }
        }
    }
}
