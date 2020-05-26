//
//  UIViewControllerExtension.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 26.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import Foundation
import UIKit

fileprivate var aView: UIView?

extension UIViewController {
    func startIndicator() {
        aView = UIView(frame: self.view.bounds)
        aView!.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = aView!.center
        activityIndicator.startAnimating()
        aView!.addSubview(activityIndicator)
        self.view.addSubview(aView!)
    }
    
    func stopIndicator() {
        aView?.removeFromSuperview()
        aView = nil
    }
}
