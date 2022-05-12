//
//  SelectedFavoriteImageViewController.swift
//  RandomImage
//
//  Created by Павел Галкин on 05.05.2022.
//

import UIKit

class SelectedFavoriteImageViewController: UIViewController {

    let selectedImage: UIImageView = {
        let imageView = UIImageView(image: .none)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let labelNoImage: UILabel = {
        let labelNoImage = UILabel()
        labelNoImage.textAlignment = .center
        labelNoImage.text = "Нет загруженных картинок"
        return labelNoImage
    }()
    
    let networkService = NetworkService.shared
    var imageId: String?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .yellow
        self.view.addSubview(selectedImage)
        
        if let imageId = imageId {
            getImage(imageId: imageId)
        } else {
            self.view.addSubview(labelNoImage)
            labelNoImage.translatesAutoresizingMaskIntoConstraints = false
            labelNoImage.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            labelNoImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            labelNoImage.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
            labelNoImage.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        selectedImage.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        selectedImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        selectedImage.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        selectedImage.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func getImage(imageId: String) {
        networkService.getImage(id: imageId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    let url = URL(string: image!.urls.regular)!
                    if let data = try? Data(contentsOf: url) {
                        self.selectedImage.image = UIImage(data: data)
                        print("image was downloaded")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}

