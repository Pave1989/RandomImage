//
//  FavoriteImagesViewCell.swift
//  RandomImage
//
//  Created by Павел Галкин on 05.05.2022.
//

import UIKit

class FavoriteImagesViewCell: UICollectionViewCell {
    
    static let identifier = "FavoriteImagesViewCell"
    
    var favoriteImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(favoriteImageView)
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        favoriteImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        favoriteImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        favoriteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
