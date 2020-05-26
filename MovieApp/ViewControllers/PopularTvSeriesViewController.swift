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
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshButtonHeight: NSLayoutConstraint!
    
    private var tvSeriesResults = [TvSeriesResult]()
    let tvSeriesServiceFetcher = TvSeriesServices()
    private var page = 1
    private var favouriteIds = [FavouritesTvSeries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshButtonShowAndHide(isChange: false)
        tableView.tableFooterView = UIView()
        getPopularTvSeries(page)
        executeRepeatedly()
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        tvSeriesResults.removeAll()
        page = 1
        getPopularTvSeries(page)
        refreshButtonShowAndHide(isChange: false)
    }
    
    func refreshButtonShowAndHide(isChange: Bool) {
        if isChange {
            self.refreshButton.isHidden = false
            self.refreshButtonHeight.constant = 40
        }else {
            self.refreshButton.isHidden = true
            self.refreshButtonHeight.constant = 0
        }
    }
    
    private func executeRepeatedly() {
        if tvSeriesResults.count > 0 {
            isSortingChange(nextPage: 1)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) { [weak self] in
            self?.executeRepeatedly()
        }
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
                self.page = result.page
                self.fetchAndSetFavouriteId()
                self.setTableView()
            }
            
            if let error = error {
                print("Status Code:", error.status_code)
                print("Status Message:", error.status_message)
            }
            
        })
    }
    
    
    private func isSortingChange(nextPage: Int) {
        tvSeriesServiceFetcher.getPopularTvSeries(page:nextPage, {result, error in
            
            if let result = result {
                var index = 0
                var j = result.page * 20 - 20

                while index < result.results.count {
                    if self.tvSeriesResults[j].id != result.results[index].id {
                        print("Sıralama Hatalı")
                        self.refreshButtonShowAndHide(isChange: true)
                        return
                    }
                    j += 1
                    index += 1
                }
                
                if nextPage < self.page {
                    self.isSortingChange(nextPage: nextPage + 1)
                }else{
                    print("Sıralama doğru")
                    self.refreshButtonShowAndHide(isChange: false)
                }
 
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
        
        cell.actionBlock = {
//            print("Tıklandı")
//            print(item.original_name)
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
                getPopularTvSeries(page + 1)
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tvSeriesDetails") as! TvSeriesDetailsViewController
        
        viewController.id = tvSeriesResults[indexPath.row].id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
}





