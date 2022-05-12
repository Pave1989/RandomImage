//
//  ImageInfo.swift
//  RandomImage
//
//  Created by Павел Галкин on 05.05.2022.
//

import Foundation

struct ImageInfo: Codable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let color: String
    let urls: ImageUrls
    let user: ImageOwnerInfo
}

struct ImageUrls: Codable {
    let regular: String
}

struct ImageOwnerInfo: Codable {
    let name: String
}
