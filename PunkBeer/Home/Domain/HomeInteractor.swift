//
//  HomeInteractor.swift
//  PunkBeer
//
//  Created by MacDD02 on 07/07/17.
//  Copyright © 2017 darlandev. All rights reserved.
//

import UIKit
import RxSwift

protocol HomeInput {
    func searchBeers(query: String?)
}

protocol HomeOutput: class {
    func foundBeers(beers:[Beer]?)
}

class HomeInteractor {
    
    weak var output: HomeOutput?
    let dispose = DisposeBag()
}

extension HomeInteractor: HomeInput {
    
    func searchBeers(query: String?) {
        API
            .getBeers(byName: query)
            .bindNext {[weak self] (repositories) in
                guard let strongSelf = self else { return }
                strongSelf.output?.foundBeers(beers: repositories)
            }
            .addDisposableTo(dispose)
    }
}
