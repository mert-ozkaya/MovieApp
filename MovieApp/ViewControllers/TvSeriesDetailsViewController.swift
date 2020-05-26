//
//  TvSeriesDetailsViewController.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 26.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import UIKit

class TvSeriesDetailsViewController: UIViewController {

    public var id: Int!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let tvSeriesServiceFetcher = TvSeriesServices()

    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailsOfTvSeries(id)
    }
    
    func setData(_ details: DetailsOfTvSeriesModel) {
        if let posterPath = details.poster_path {
            print(posterPath)
            self.posterImageView.setImage(posterPath, photoType: "w780")
        }
        
        self.titleLabel.text = details.name
        

    }
    
    
    private func getDetailsOfTvSeries(_ id: Int) {
        
        tvSeriesServiceFetcher.getDetailsOfTvSeries(id:id, {result, error in
            if let result = result {
                self.setData(result)
            }
            
            if let error = error {
                print("Status Code:", error.status_code)
                print("Status Message:", error.status_message)
            }
            
        })
    }
}
