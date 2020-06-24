//
//  ImageCache.swift
//  PhotosTests
//
//  Created by Elizaveta Konysheva on 24.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import UIKit
@testable import Photos

class ImageCacheMock: ImageCache {

    private(set) var callCount = 0
    private(set) var loadUrl: URL?

    var answer: UIImage?

    func load(url: URL, completion: @escaping (UIImage?) -> Void) {
        callCount += 1
        loadUrl = url
        completion(answer)
    }
}
