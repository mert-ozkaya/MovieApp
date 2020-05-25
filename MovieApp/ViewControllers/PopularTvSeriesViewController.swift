//
//  PopularTvSeriesViewController.swift
//  MovieApp
//
//  Created by Mert Ozkaya on 24.05.2020.
//  Copyright © 2020 Mert Ozkaya. All rights reserved.
//

import UIKit
import Swinject
import CoreData

class PopularTvSeriesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

//    private var tvSeries: TvSeriesModel?
    private var tvSeriesResults = [TvSeriesResult]()
    let tvSeriesObject = TvSeriesServices()
    private var page = 1
    private var favouriteIds = [FavouritesTvSeries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        let fetchRequest: NSFetchRequest<FavouritesTvSeries> = FavouritesTvSeries.fetchRequest()
        
        do{
            let favourites = try PersistenceService.context.fetch(fetchRequest)
            favouriteIds = favourites
        }catch {}
        
        getPopularTvSeries(page)
    }
    
    private func setTableView() {
        self.tableView.rowHeight = 120
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    private func getPopularTvSeries(_ page: Int) {
        tvSeriesObject.getPopularTvSeries(page:page, {result, error in
            if let result = result {
                self.tvSeriesResults.append(contentsOf: result.results)
                self.page = result.page + 1
                self.setTableView()
            }
            
            if let error = error {
                print("Status Code:", error.status_code)
                print("Status Message:", error.status_message)
            }
            
        })
    }
    
    
    private func deleteFavouriteFromCoreData(index: Int) {
        let context:NSManagedObjectContext = PersistenceService.context
         context.delete(favouriteIds[index])
         
         favouriteIds.remove(at: index)
        do {
            try context.save()
            tableView.reloadData()
        } catch _ {
        }
    }
}

extension PopularTvSeriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tvSeriesResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularTvSeriesCell", for: indexPath) as! PopularTvSeriesCell
        
        let item = tvSeriesResults[indexPath.row]
        cell.setupUI(item, indexPath.row + 1, favouriteIds: favouriteIds)
        
        cell.actionBlock = {
            let favouriteTvSeries = FavouritesTvSeries(context: PersistenceService.context)
            favouriteTvSeries.id = Int32(item.id)
            PersistenceService.saveContext()
            
            for favouriteItem in self.favouriteIds {
                if favouriteItem.id == item.id self.favouriteIds {
                    
                }else if self.favouriteIds.count == self.favouriteIds.inde
            }
            
            self.favouriteIds.append(favouriteTvSeries)
            
            cell.favouriteBookmarkLabel.text = "Favorilerimden Çıkar"
            cell.favouriteBookmarkIcon.image = UIImage(systemName: "bookmark.fill")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
            if indexPath.row == tvSeriesResults.count-1 {
                getPopularTvSeries(page)
            }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
    
}





