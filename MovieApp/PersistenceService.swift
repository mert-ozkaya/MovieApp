//
//  PersistenceService.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 25.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import Foundation
import CoreData


class PersistenceService {
    
    private init() {}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "favourites")
        container.loadPersistentStores(completionHandler: {storeDescription, error in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
        })
        return container
    }()
    
    static func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            }catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    static func deleteContextById(array: [FavouritesTvSeries], id: Int) {
        let context:NSManagedObjectContext = PersistenceService.context
        var  i = 0
        while i < array.count {
            if array[i].id == id {
                context.delete(array[i])
            }
            i += 1
        }
        
        do {
        try context.save()
        } catch _ {}
        
    }
    
    static func isContainId() {
        
    }


}

