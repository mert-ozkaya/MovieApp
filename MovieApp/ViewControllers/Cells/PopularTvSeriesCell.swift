//
//  PopularTvSeriesCell.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 24.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import UIKit

class PopularTvSeriesCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterOfTvSeries: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favouriteView: UIView!
    @IBOutlet weak var favouriteBookmarkIcon: UIImageView!
    @IBOutlet weak var favouriteBookmarkLabel: UILabel!
    
    // cell içerisindeki Favorilerime Ekle ve Çıkar butonuna basıldığında bu action çalışacak
    var actionBlock: (() -> Void)? = nil

    
    @objc func tapFavourite(_ sender:UITapGestureRecognizer) {
        actionBlock?()
    }
    
    func setupUI(_ tvSeriesResult: TvSeriesResult,_ rankingNumber: Int) {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFavourite))
        favouriteView.isUserInteractionEnabled = true
        favouriteView.addGestureRecognizer(tap)
        
        self.titleLabel.text = tvSeriesResult.original_name
        self.numberLabel.text = String(rankingNumber) + ". "
        self.ratingLabel.text = String(tvSeriesResult.vote_average)
        
        if tvSeriesResult.isFavourite {
            self.favouriteBookmarkLabel.text = "Favorilerimden Çıkar"
            self.favouriteBookmarkIcon.image = UIImage(systemName: "bookmark.fill")
        }else {
            self.favouriteBookmarkLabel.text = "Favorilerime Ekle"
            self.favouriteBookmarkIcon.image = UIImage(systemName: "bookmark")
        }
    
        if let poster_path = tvSeriesResult.poster_path {
            self.posterOfTvSeries.setImage(poster_path, photoType: "w92")
        }
    }

}
