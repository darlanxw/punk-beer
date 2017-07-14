//
//  HomeRouter.swift
//  PunkBeer
//
//  Created by MacDD02 on 07/07/17.
//  Copyright © 2017 darlandev. All rights reserved.
//

import UIKit

class HomeRouter : NSObject {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var homeTableViewController:HomeTableViewController
    let presenter = HomePresenter()
    let interactor = HomeInteractor()
    
    override init() {
        homeTableViewController = storyboard.instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
        
        super.init()
        
        homeTableViewController.presenter = presenter
        presenter.view = homeTableViewController
        presenter.router = self
        presenter.interactor = interactor
        interactor.output = presenter
    }
    
    func present(window: UIWindow) {
        let navigation = UINavigationController(rootViewController: homeTableViewController)
        window.rootViewController = navigation
    }
    
    func presentDetails(forBeer beer: Beer) {
        let detailsTableViewController = DetailRouter.assembleModule(beer)
        homeTableViewController.show(detailsTableViewController, sender: nil)
    }
}
