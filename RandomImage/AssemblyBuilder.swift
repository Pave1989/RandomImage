//
//  AssemblyBuilder.swift
//  RandomImage
//
//  Created by Павел Галкин on 05.05.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createRandomImageModule() -> UIViewController
    func createFavoriteImagesModule() -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createRandomImageModule() -> UIViewController {
        let view = RandomImageViewController()
        let networkService = NetworkService.shared
        let presenter = RandomImagePresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    func createFavoriteImagesModule() -> UIViewController {
        let view = FavoriteImagesViewController()
        return view
    }
}
