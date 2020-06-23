//
//  PhotoDetailsViewModel.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 23.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoDetailsViewModel {
    var output: PhotoDetails.Output? { get set }
}

extension PhotoDetails {
    struct Context {
        let api: API
        let imageLoader: ImageLoader
    }

    struct Output {
        let photoTitle: (String) -> Void
        let photoImage: (UIImage) -> Void
        let error: (String) -> Void
    }

    final class ViewModel: PhotoDetailsViewModel {
        var output: Output?
        private let context: Context

        init(context: Context, photoId: Int) {
            self.context = context
            loadPhoto(with: photoId)
        }

        private func loadPhoto(with id: Int) {
            context.api.call(endpoint: .getPhoto(id)) { [weak self] (result: Result<Photo, NetworkError>) in
                switch result {
                case .success(let photo):
                    self?.output?.photoTitle(photo.title)
                    self?.loadImage(with: photo.url)
                case .failure(let error):                    
                    self?.output?.error(error.title)
                }
            }
        }

        private func loadImage(with url: URL) {
            context.imageLoader.loadImage(from: url) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.output?.photoImage(image)
                case .failure(let error):
                    self?.output?.error(error.title)
                }
            }
        }
    }
}
