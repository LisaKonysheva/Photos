//
//  NetworkService.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 22.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkService {
    func load(urlRequest: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

enum NetworkError: Error {
    case serverError(Error)
    case noConnection
    case noData
    case decodingError

    var title: String {
        switch self {
        case .serverError, .noData, .decodingError:
            return "Server error occured"
        case .noConnection:
            return "Your device is offline"
        }
    }
}

struct NetworkServiceImpl: NetworkService {
    func load(urlRequest: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                guard let code = (error as? URLError)?.code, code == .notConnectedToInternet else {
                    completion(.failure(NetworkError.serverError(error)))
                    return
                }
                completion(.failure(NetworkError.noConnection))
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
