//
//  ImageLoader.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 23.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import UIKit

protocol ImageLoader {
    func loadImage(from: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void)
}

struct ImageLoaderImpl: ImageLoader {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func loadImage(from url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        let request = URLRequest(url: url)
        networkService.load(urlRequest: request) { result in
            switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        DispatchQueue.main.async {
                             completion(.failure(NetworkError.decodingError))
                         }
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
            }
        }
    }
}
