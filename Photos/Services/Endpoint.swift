//
//  Endpoint.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 22.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
}

struct Request {
    let method: HTTPMethod
    let path: String
}

enum Endpoint {
    case getPhotos
    case getPhoto(Int)

    func makeRequest() -> Request {
        switch self {
        case .getPhotos:
            return Request(method: .GET, path: "/photos")
        case .getPhoto(let photoId):
            return Request(method: .GET, path: "/photos/\(photoId)")
        }
    }
}
