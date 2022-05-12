//
//  RandomImagePresenter.swift
//  RandomImage
//
//  Created by Павел Галкин on 05.05.2022.
//

import Foundation

protocol RandomImageViewProtocol: AnyObject {
    func successGetingRandomImage(image: ImageInfo)
    func failureGettingrandomImage(error: Error)
    func getRandomImage()
}

protocol RandomImagePresenterProtocol {
    init (view: RandomImageViewProtocol, networkService: RandomImageGetable)
    func getRandomImage()
    var randomImage: ImageInfo? { get set }
}

class RandomImagePresenter: RandomImagePresenterProtocol {
    var randomImage: ImageInfo?
    weak var randomImageView: RandomImageViewProtocol?
    let networkService: RandomImageGetable
    
    required init(view: RandomImageViewProtocol, networkService: RandomImageGetable) {
        self.randomImageView = view
        self.networkService = networkService
    }
    
    func getRandomImage() {
        networkService.getImage(id: nil) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let randomImage):
                    self.randomImage = randomImage!
                    self.randomImageView?.successGetingRandomImage(image: self.randomImage!)
                case .failure(let error):
                    self.randomImageView?.failureGettingrandomImage(error: error)
                }
            }
        }
    }
}
