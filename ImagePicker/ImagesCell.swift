//
//  ImagesCell.swift
//  ImagePicker
//
//  Created by Rish on 06/10/18.
//  Copyright © 2018 Rish. All rights reserved.
//

import UIKit

class ImagesCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 0.3)
        addSubview(mainImage)
        mainImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        mainImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        mainImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        mainImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        mainImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainImage : UIImageView = {
    let imageView = UIImageView()
        imageView.image = UIImage(named: "image-1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
}
