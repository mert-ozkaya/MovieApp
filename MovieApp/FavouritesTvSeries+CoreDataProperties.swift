//
//  FavouritesTvSeries+CoreDataProperties.swift
//  
//
//  Created by Mert Ozkaya on 25.05.2020.
//
//

import Foundation
import CoreData


extension FavouritesTvSeries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouritesTvSeries> {
        return NSFetchRequest<FavouritesTvSeries>(entityName: "FavouritesTvSeries")
    }

    @NSManaged public var id: Int32

}
