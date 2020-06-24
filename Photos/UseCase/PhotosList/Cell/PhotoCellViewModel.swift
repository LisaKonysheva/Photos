//
//  PhotoCellViewModel.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 23.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import UIKit

final class PhotoCellViewModel: Hashable {
    static func == (lhs: PhotoCellViewModel, rhs: PhotoCellViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    let id: Int
    let title: String
    let thumbnailURL: URL
    var image: UIImage?

    private let imageCache: ImageCache

    init(photo: Photo, imageCache: ImageCache) {
        self.id = photo.id
        self.title = photo.title
        self.thumbnailURL = photo.thumbnailUrl
        self.imageCache = imageCache
    }

    func loadImage(completion: @escaping () -> Void) {
        imageCache.load(url: thumbnailURL) { [weak self] result in
            guard let result = result, result != self?.image else {
                return
            }
            self?.image = result
            completion()
        }
    }
}
