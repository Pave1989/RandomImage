//
//  APIConfig.swift
//  RandomImage
//
//  Created by Павел Галкин on 05.05.2022.
//

import Foundation

struct UnsplashConfig {
    let photoId:String?
    static let APIKey = "BqllpO9FMcrvq4uz-NaLcDEc0F8KfxZp06FFpob2WoE"
    static let randomImageEndpoint = "https://api.unsplash.com/photos/random/?client_id=\(APIKey)"
    var getImageByIdEndpoint: String {
        return "https://api.unsplash.com/photos/\(photoId ?? "1")/?client_id=\(UnsplashConfig.APIKey)"
    }
}
