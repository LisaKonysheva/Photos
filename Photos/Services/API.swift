//
//  API.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 23.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation

protocol API {
    func call<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}

struct APIImpl: API {
    private let host: String
    private let networkService: NetworkService

    init(host: String, networkService: NetworkService) {
        self.host = host
        self.networkService = networkService
    }

    func call<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let request = endpoint.makeRequest()
        let url = URL(string: request.path, relativeTo: URL(string: self.host))!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        networkService.load(urlRequest: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let result: T = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.decodingError))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
