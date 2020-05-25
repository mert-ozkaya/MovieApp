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
    func setImage(with URLString: String) {
        setImage(with: URLString, placeholder: UIImage(named: "notFound")!) // TODO: placeholder gelince değiştirilecek.
    }
    
    func setImage(with URLString: String, placeholder: UIImage) {
        let url = URL(string: URLString)
        let resource = ImageResource.init(downloadURL: url!)
        
        self.kf.setImage(with: resource, placeholder: placeholder)
        self.kf.indicator?.view.tintColor = UIColor.red
    }
    
}
