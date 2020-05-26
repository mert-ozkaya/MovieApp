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

    private var tvSeriesResults = [TvSeriesResult]()
    let tvSeriesServiceFetcher = TvSeriesServices()
    private var page = 1
    private var favouriteIds = [FavouritesTvSeries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        getPopularTvSeries(page)
    }
    
    private func fetchAndSetFavouriteId() {
        let fetchRequest: NSFetchRequest<FavouritesTvSeries> = FavouritesTvSeries.fetchRequest()
        
        do{
            let favourites = try PersistenceService.context.fetch(fetchRequest)
            favouriteIds = favourites
            for item in favouriteIds {
                for result in tvSeriesResults {
                    if item.id == result.id {
                        result.isFavourite = true
                    }
                }
            }
        }catch {}
    }
    
    private func setTableView() {
        self.tableView.rowHeight = 120
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    private func getPopularTvSeries(_ page: Int) {
        tvSeriesServiceFetcher.getPopularTvSeries(page:page, {result, error in
            if let result = result {
                self.tvSeriesResults.append(contentsOf: result.results)
                self.page = result.page + 1
                self.fetchAndSetFavouriteId()
                self.setTableView()
            }
            
            if let error = error {
                print("Status Code:", error.status_code)
                print("Status Message:", error.status_message)
            }
            
        })
    }
    
    
    private func deleteFavouriteById(_ id: Int) {
        let context:NSManagedObjectContext = PersistenceService.context
        var  i = 0
        while i < favouriteIds.count {
            if favouriteIds[i].id == id {
                context.delete(favouriteIds[i])
                favouriteIds.remove(at: i)
                break
            }
            i += 1
        }
        
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
        cell.setupUI(item, indexPath.row + 1)
        
        //print("indexPath:", indexPath.row)
        cell.actionBlock = {
            print("Tıklandı")
            print(item.original_name)
            
            
            if item.isFavourite{
                self.deleteFavouriteById(item.id)
                item.isFavourite = false
                tableView.reloadData()
            }else {
                item.isFavourite = true
                let favouriteTvSeries = FavouritesTvSeries(context: PersistenceService.context)
                favouriteTvSeries.id = Int32(item.id)
                self.favouriteIds.append(favouriteTvSeries)
                PersistenceService.saveContext()
                tableView.reloadData()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == tvSeriesResults.count-1 {
                getPopularTvSeries(page)
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tvSeriesDetails") as! TvSeriesDetailsViewController
        
        viewController.id = tvSeriesResults[indexPath.row].id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
}





