//
//  UIImageExtension.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 25.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    func setImage(_ imagePath: String, photoType: String) {
        let imageUrl = "https://image.tmdb.org/t/p/" + photoType  + imagePath
        setImage(with: imageUrl, placeholder: UIImage(named: "notFound")!)
    }
    
    func setImage(with URLString: String, placeholder: UIImage) {
        let url = URL(string: URLString)
        let resource = ImageResource.init(downloadURL: url!)
        
        self.kf.setImage(with: resource, placeholder: placeholder)
        self.kf.indicator?.view.tintColor = UIColor.red
    }
    
}
