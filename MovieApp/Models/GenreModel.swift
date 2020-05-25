//
//  GenreModel.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 25.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import Foundation
import SwiftyJSON

class GenreModel{
    var id: Int
    var name: String
    
    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
    }
}
