//
//  TvSeries.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 24.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import Foundation
import SwiftyJSON

class TvSeriesModel {
    var page: Int
    var total_results: Int
    var total_pages: Int
    var results = [TvSeriesResult]()
    
    
    init(json: JSON) {
        page = json["page"].intValue
        total_results = json["total_results"].intValue
        total_pages = json["total_pages"].intValue
        
        let resultsArray = json["results"].arrayValue
        for item in resultsArray {
            results.append(TvSeriesResult(json: JSON(item)))
        }
    }
}

class TvSeriesResult{
    var id: Int
    var original_name: String
    var vote_average: Float
    var poster_path: String?
    
    var isFavourite:Bool = false

    init(json: JSON) {
        id = json["id"].intValue
        original_name = json["original_name"].stringValue
        vote_average = json["vote_average"].floatValue
        poster_path = json["poster_path"].string
    }
    
}
