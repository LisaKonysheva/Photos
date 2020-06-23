//
//  PhotoCellViewModel.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 23.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import UIKit

final class PhotoCellViewModel: Hashable, Equatable {
    static func == (lhs: PhotoCellViewModel, rhs: PhotoCellViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var imageUpdated: ((UIImage) -> Void)?
    let thumbnailURL: URL
    let title: String
    let id: Int

    private let imageCache: ImageCache

    init(photo: Photo, imageCache: ImageCache) {
        self.id = photo.id
        self.title = photo.title
        self.thumbnailURL = photo.thumbnailUrl
        self.imageCache = imageCache
    }

    func loadImage() {
        imageCache.load(url: thumbnailURL) { [weak self] image in
            guard let image = image else {
                return
            }
            self?.imageUpdated?(image)
        }
    }
}
