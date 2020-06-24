//
//  ApiMock.swift
//  PhotosTests
//
//  Created by Elizaveta Konysheva on 24.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation
@testable import Photos

class APIMock: API {
    private(set) var callCount = 0
    private(set) var endpointInvoked: Endpoint?

    private var answer: Result<Any, NetworkError>?
    func answer(with answer: Result<Any, NetworkError>) {
        self.answer = answer
    }

    func call<T>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        callCount += 1
        endpointInvoked = endpoint

        mockAnswer(with: answer, completion: completion)
    }

    func mockAnswer<T>(
        with value: Result<Any, NetworkError>?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let answer = value else {
            completion(.failure(NetworkError.noData))
            return
        }
        switch answer {
        case .success(let value):
            guard let responseValue = value as? T else {
                fatalError("The answer type is wrong or missing. Expected: \(T.self), got \(String(describing: value))")
            }
            completion(.success(responseValue))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
