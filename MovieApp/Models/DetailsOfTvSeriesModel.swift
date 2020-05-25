//
//  DetailsOfTvSeriesModel.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 25.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import Foundation
import SwiftyJSON

class DetailsOfTvSeriesModel {

    var name: String
    var vote_average: Float
    var number_of_seasons: Int
    var number_of_episodes: Int
    var poster_path: String?
    var backdrop_path: String?
    var genres = [GenreModel]()
    var overview: String
    
    init(json: JSON) {
        backdrop_path = json["backdrop_path"].string
        
        let _genres = json["genres"].arrayValue
        for item in _genres {
            genres.append(GenreModel(json: item))
        }
        
        name = json["name"].stringValue
        vote_average = json["vote_average"].floatValue
        number_of_seasons = json["number_of_seasons"].intValue
        number_of_episodes = json["number_of_episodes"].intValue
        poster_path = json["poster_path"].stringValue
        overview = json["overview"].stringValue
        
    }
}
