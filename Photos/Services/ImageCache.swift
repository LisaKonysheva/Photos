//
//  ImageCache.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 23.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import UIKit

protocol ImageCache {
    func load(url: URL, completion: @escaping (UIImage?) -> Void)
}

final class ImageCacheImpl: ImageCache {
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var completions = [NSURL: [(UIImage?) -> Void]]()
    private let imageLoader: ImageLoader

    init(imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
    }

    func load(url: URL, completion: @escaping (UIImage?) -> Void) {
        let urlKey = url as NSURL
        if let cachedImage = cachedImages.object(forKey: urlKey) {
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
                self?.cachedImages.setObject(image, forKey: urlKey)
                self?.completions[urlKey]?.forEach { $0(image) }
            case .failure:
                self?.completions[urlKey]?.forEach { $0(nil) }
            }
        }
    }
}
