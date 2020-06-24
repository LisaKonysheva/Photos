//
//  PhotosTableViewModel.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 22.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation

protocol PhotosListViewModel {
    var output: PhotosList.Output? { get set }
    func loadItems()
    func photoSelected(_ viewModel: PhotoCellViewModel)
}

extension PhotosList {
    struct Context {
        let api: API
        let imageCache: ImageCache
    }

    struct Handlers {
        let photoSelected: (Int) -> Void
    }

    struct Output {
        let photoItems: ([PhotoCellViewModel]) -> Void
        let error: (String) -> Void
    }

    final class ViewModel: PhotosListViewModel {
        var output: Output?
        private var handlers: Handlers
        private let context: Context

        init(context: Context, handlers: Handlers) {
            self.handlers = handlers
            self.context = context
        }

        func loadItems() {
            context.api.call(endpoint: .getPhotos) { [weak self] (result: Result<[Photo], NetworkError>) in
                guard let self = self else { return }
                switch result {
                case .success(let photos):
                    let items = photos.map { PhotoCellViewModel(
                        photo: $0,
                        imageCache: self.context.imageCache)
                    }
                    self.output?.photoItems(items)
                case .failure(let error):
                    self.output?.error(error.title)
                }
            }
        }

        func photoSelected(_ viewModel: PhotoCellViewModel) {
            handlers.photoSelected(viewModel.id)
        }
    }
}
