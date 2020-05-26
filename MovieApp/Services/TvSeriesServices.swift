//
//  TvSeriesServices.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 24.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON




class TvSeriesServices {
    private let BASE_URL = "https://api.themoviedb.org"
    private let api_key = "0b3df41bfff0d5fd912cf1d6f9cdfaf1"
    private var API: String
    
    init() {
        self.API = self.BASE_URL + "/3/tv"
    }

    public func getPopularTvSeries(page: Int, _ handler: @escaping(TvSeriesModel?, ErrorModel?) -> Void) {
        let url = self.API + "/popular" + "?api_key=" + api_key + "&page=" + String(page)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            
            if let status = response.response?.statusCode {
                if status == 401 || status == 404 {
                    if let errorData = response.data {
                        let errorModel = ErrorModel(json: JSON(errorData))
                        handler(nil, errorModel)
                    }
                }else {
                    switch response.result {
                    case .success(let value):
                        let popularTvSeries = TvSeriesModel(json: JSON(value))
                        handler(popularTvSeries, nil)
                    case .failure(let error):
                        print(error)
                        if let errorData = response.data {
                            handler(nil,ErrorModel(json: JSON(errorData)))
                        }
                    }
                }
            }
        }
    }

    public func getDetailsOfTvSeries(id: Int, _ handler: @escaping(DetailsOfTvSeriesModel?, ErrorModel?) -> Void) {
        let url = self.API + "/" + String(id) + "?api_key=" + api_key
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            
            if let status = response.response?.statusCode {
                if status == 401 || status == 404 {
                    if let errorData = response.data {
                        let errorModel = ErrorModel(json: JSON(errorData))
                        handler(nil, errorModel)
                    }
                }else {
                    switch response.result {
                    case .success(let value):
                        let detailsOfTvSeries = DetailsOfTvSeriesModel(json: JSON(value))
                        handler(detailsOfTvSeries, nil)
                    case .failure(let error):
                        print(error)
                        if let errorData = response.data {
                            handler(nil,ErrorModel(json: JSON(errorData)))
                        }
                    }
                }
            }
        }
    }

}
