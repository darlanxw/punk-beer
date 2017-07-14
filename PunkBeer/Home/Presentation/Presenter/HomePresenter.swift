//
//  HomePresentation.swift
//  PunkBeer
//
//  Created by MacDD02 on 07/07/17.
//  Copyright © 2017 darlandev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol HomePresenterProtocol {
    var numberOfRows: Int {get}
    var beersChanged: Observable<Void> {get}
    
    func viewDidLoad()
    func getItem(indexPath: IndexPath) -> Beer?
    func clearData()
    func didSelectArticle(_ beer: Beer)

}

class HomePresenter {
    weak var view: HomeProtocol?
    var interactor: HomeInput!
    var router:HomeRouter!
    //wireFrame
    
    let dispose = DisposeBag()
    
    var beers = Variable<[Beer]>([])
    
    func bind() {
        if let viewProtocol = view {
            viewProtocol.searchBarTextObservable
                .filter({ (text) -> Bool in
                    return text!.characters.count >= 3
                })
                .debounce(0.8, scheduler: MainScheduler.instance)
                .bindNext({[weak self] (query) in
                    guard let strongSelf = self, let query = query else { return }
                    strongSelf.search(query: query)
                })
                .addDisposableTo(dispose)
        }
    }
    
    func search(query: String?){
        self.clearData()
        self.view?.reloadTableView()
        self.view?.setVisibilityActivityIndicator(isVisible: true)
        self.interactor.searchBeers(query: query)
    }
}

extension HomePresenter: HomePresenterProtocol {
    
    var numberOfRows: Int {
        return self.beers.value.count
    }
    
    var beersChanged: Observable<Void> {
        return beers.asObservable().map({ (_) -> Void in
            
        })
    }
    
    func viewDidLoad() {
        bind()
        search(query: nil)
    }
    
    func getItem(indexPath: IndexPath) -> Beer? {
        return beers.value[indexPath.row]
    }
    
    func clearData(){
        beers = Variable<[Beer]>([])
    }
    
    func didSelectArticle(_ beer: Beer) {
        router.presentDetails(forBeer: beer)
    }
}

extension HomePresenter: HomeOutput {
    
    func foundBeers(beers: [Beer]?) {
        guard let beers = beers else {return}
        view?.setVisibilityActivityIndicator(isVisible: false)
        self.beers.value = beers
        view?.reloadTableView()
    }
}

