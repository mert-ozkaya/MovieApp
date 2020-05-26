//
//  ErrorModel.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 24.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import Foundation
import SwiftyJSON

class ErrorModel {
    var status_message: String
    var status_code: Int
    
    init(json: JSON) {
        status_message = json["status_message"].stringValue
        status_code = json["status_code"].intValue
    }
}
