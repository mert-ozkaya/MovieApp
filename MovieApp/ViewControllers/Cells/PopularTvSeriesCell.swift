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
    var actionBlock: (() -> Void)? = nil

    @objc func tapFavourite(_ sender:UITapGestureRecognizer) {
        actionBlock?()
    }
    
    //    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    func setupUI(_ tvSeriesResult: TvSeriesResult,_ rankingNumber: Int, favouriteIds: [FavouritesTvSeries]) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFavourite))
        favouriteView.isUserInteractionEnabled = true
        favouriteView.addGestureRecognizer(tap)
        
        self.titleLabel.text = tvSeriesResult.original_name
        self.numberLabel.text = String(rankingNumber) + ". "
        self.ratingLabel.text = String(tvSeriesResult.vote_average)
        
        for favouriteObject in favouriteIds {
            if tvSeriesResult.id == favouriteObject.id {
                self.favouriteBookmarkLabel.text = "Favorilerimden Çıkar"
                self.favouriteBookmarkIcon.image = UIImage(systemName: "bookmark.fill")
            }else {
                self.favouriteBookmarkLabel.text = "Favorilerimden Ekle"
                self.favouriteBookmarkIcon.image = UIImage(systemName: "bookmark")
            }
        }
    
        print(tvSeriesResult.id)
        if let poster_path = tvSeriesResult.poster_path {
            let imageUrl = "https://image.tmdb.org/t/p/w92" + poster_path
            self.posterOfTvSeries.setImage(with: imageUrl)
        }else {
            print("poster boş")
        }
        
        
    }

}
