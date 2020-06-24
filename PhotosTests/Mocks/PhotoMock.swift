//
//  PhotoMock.swift
//  PhotosTests
//
//  Created by Elizaveta Konysheva on 24.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation
@testable import Photos

extension Photo {
    static func mock(with id: Int = 1) -> Photo {
        Photo(
            id: id,
            title: "TestPhoto",
            thumbnailUrl: URL(string: "https://via.placeholder.com/150/771796")!,
            url: URL(string: "https://via.placeholder.com/600/771796")!
        )
    }
}
