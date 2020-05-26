//
//  TvSeriesDetailsViewController.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 26.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import UIKit
import CoreData

class TvSeriesDetailsViewController: UIViewController {

    public var id: Int!
    public var isFavourite = false
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favouriteIcon: UIImageView!
    @IBOutlet weak var favouriteLabel: UILabel!
    @IBOutlet weak var seasonCountLabel: UILabel!
    @IBOutlet weak var episodesCountLabel: UILabel!
    
    private let tvSeriesServiceFetcher = TvSeriesServices()
    public var favouritesTvSeries = [FavouritesTvSeries]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailsOfTvSeries(id)
    }
    
    func fetchAndTvSeries() {
        let fetchRequest: NSFetchRequest<FavouritesTvSeries> = FavouritesTvSeries.fetchRequest()
            do{
                let favourites = try PersistenceService.context.fetch(fetchRequest)
                favouritesTvSeries = favourites
            }catch {}
    }
    
    
    func favouriteConfiguration(isFav: Bool) {
        if isFav{
            self.favouriteIcon.image = UIImage(systemName: "bookmark.fill")
            self.favouriteLabel.text = "Favorilerimden Çıkar"
        }else{
            self.favouriteIcon.image = UIImage(systemName: "bookmark")
            self.favouriteLabel.text = "Favorilerime Ekle"
        }
    }
    
    @objc func tapFavourite(_ sender:UITapGestureRecognizer) {
        
        if self.isFavourite{ // Tv dizisi favorilerdeyse
            PersistenceService.deleteContextById(array: self.favouritesTvSeries, id: self.id)
            self.isFavourite = false
        }else{ // Tv dizisi favorilerde değilse
            self.isFavourite = true
            let favouriteTvSeries = FavouritesTvSeries(context: PersistenceService.context)
            favouriteTvSeries.id = Int32(self.id)
            self.isFavourite = true
            PersistenceService.saveContext()
        }
        self.favouriteConfiguration(isFav: self.isFavourite)

    }
    
    func setData(_ details: DetailsOfTvSeriesModel) {
        if let posterPath = details.poster_path {
            self.posterImageView.setImage(posterPath, photoType: "w780")
        }
        
        self.titleLabel.text = details.name
        self.overviewLabel.text = details.overview
        self.ratingLabel.text = String(details.vote_average) + " / 10.0"
        
        var genres = ""
        var i = 0
        while i < details.genres.count {
            if(i == 0) {
                genres = details.genres[i].name
            }else {
                genres = genres + ", " + details.genres[i].name

            }
            i += 1
        }
        self.genresLabel.text = genres
        self.seasonCountLabel.text = String(details.number_of_seasons) + " Season"
        self.episodesCountLabel.text = String(details.number_of_episodes) + " Episodes"
        
    }
    
    
    private func getDetailsOfTvSeries(_ id: Int) {
        self.startIndicator()
        tvSeriesServiceFetcher.getDetailsOfTvSeries(id:id, {result, error in
            if let result = result {
                self.setData(result)
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFavourite))
                self.favouriteLabel.isUserInteractionEnabled = true
                self.favouriteLabel.addGestureRecognizer(tap)
                self.fetchAndTvSeries()
                self.favouriteConfiguration(isFav: self.isFavourite)
                self.stopIndicator()
            }
            
            if let error = error {
                print("Status Code:", error.status_code)
                print("Status Message:", error.status_message)
                self.stopIndicator()
            }
            
        })
    }
}
