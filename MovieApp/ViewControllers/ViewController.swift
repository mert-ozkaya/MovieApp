//
//  ViewController.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 24.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import UIKit

class PopularTvSeriesViewController: BaseViewController {

//    private var popularTvSeries: TvSeries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deneme = TvSeriesServices()
        deneme.getPopularTvSeries({result in
            if let result = result{
                print(result)
            }
        })
    }


}

