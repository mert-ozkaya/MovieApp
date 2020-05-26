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


protocol FavTvSeries {
    
}

class PopularTvSeriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshButtonHeight: NSLayoutConstraint!
    
    private var tvSeriesResults = [TvSeriesResult]()
    let tvSeriesServiceFetcher = TvSeriesServices()
    
    private var page = 1
    // local storage içindeki favorilerin nesneleri bu dizide tutulacak
    private var favouriteIds = [FavouritesTvSeries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshButtonShowAndHide(isChange: false)
        tableView.tableFooterView = UIView()
        getPopularTvSeries(page)
        executeRepeatedly()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAndSetFavouriteId()
        self.tableView.reloadData()
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
    
    // Her dakika başı çalışarak listede değişiklik olup olmadığını kontrol eden metod
    private func executeRepeatedly() {
        if tvSeriesResults.count > 0 {
            isSortingChange(nextPage: 1)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) { [weak self] in
            self?.executeRepeatedly()
        }
    }
    
    //Local dataların çekilmesini sağlar
    //Çekilen datalar tvSeriesResults dizisine set edilir.
    private func fetchAndSetFavouriteId() {
        let fetchRequest: NSFetchRequest<FavouritesTvSeries> = FavouritesTvSeries.fetchRequest()
        
        for result in tvSeriesResults {
            result.isFavourite = false
        }
        
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
            self.tableView.reloadData()
        }catch {}
    }
    
    private func setTableView() {
        self.tableView.rowHeight = 120
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    // Popüler tv dizilerinin çekilip set edildiği fonksiyon
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
    
    /*
     Fonksiyonun çalıştığı andaki sayfa numarasına kadar sırayla recursive olarak
     ilerlenerek her bir tv dizisinin yerinin sabit kalıp kalmadığı kontrol edilir
     Yeri değişen tv dizisi bulunduğunda ekranda Yenilen butonu çıkarılır
     Recursive metodlardan çıkılır
    */
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
                
                if nextPage < self.page { // son sayfa numarasına gelinmemişse
                    self.isSortingChange(nextPage: nextPage + 1)
                }else{ // son sayfa numarasına gelişmişse sıralama doğru kabul edilir  ve refresh butonu gizlenir duruma getirilir.
                    print("Sıralama doğru")
                    self.refreshButtonShowAndHide(isChange: false)
                }
            }
        })
    }
    
    //local datalar içerisinde id ile arama yapılarak local datalardan silme işlemini sağlayan metod
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

//MARK: TableView Processes
extension PopularTvSeriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tvSeriesResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularTvSeriesCell", for: indexPath) as! PopularTvSeriesCell
        let item = tvSeriesResults[indexPath.row]
        cell.setupUI(item, indexPath.row + 1)
        
        // favorilerime ekle ve çıkarma view'e tıklanıldığında
        cell.actionBlock = {
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
    
    //Infinite scroll işleminin sağlandığı yer
    //Görüntülenen indexPath.row son cellden bir öncesindeyse bir sonraki sayfa numarası ile veriler çekilir
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == tvSeriesResults.count-1 {
                getPopularTvSeries(page + 1)
            }
    }
    
    //Cell'e tıklanıldığında detaylar sayfasına yönlendirme yapılan fonk.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tvSeriesDetails") as! TvSeriesDetailsViewController
        
        viewController.id = tvSeriesResults[indexPath.row].id
        for item in favouriteIds {
            if item.id == tvSeriesResults[indexPath.row].id {
                viewController.isFavourite = true
                break
            }
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
}





