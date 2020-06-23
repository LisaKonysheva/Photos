//
//  Photo.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 22.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let id: Int
    let title: String
    let thumbnailUrl: URL
    let url: URL
}
