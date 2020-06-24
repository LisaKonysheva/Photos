//
//  ImageLoaderMock.swift
//  PhotosTests
//
//  Created by Elizaveta Konysheva on 24.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import UIKit
@testable import Photos

class ImageLoaderMock: ImageLoader {

    private(set) var callCount = 0
    private(set) var loadUrl: URL?

    var answer: Result<UIImage, NetworkError>?

    func loadImage(
        from: URL,
        completion: @escaping (Result<UIImage, NetworkError>) -> Void
    ) {
        callCount += 1
        loadUrl = from
        guard let answer = answer else {
            completion(.failure(NetworkError.noData))
            return
        }
        completion(answer)
    }
}

class ImageStoreMock: ImageStore {
    var store = [NSURL: UIImage]()

    var getImageCalledCount = 0
    func image(forUrl url: NSURL) -> UIImage? {
        getImageCalledCount += 1
        return store[url]
    }

    var setImageCalledCount = 0
    func set(image: UIImage, forKey key: NSURL) {
        setImageCalledCount += 1
        store[key] = image
    }
}
