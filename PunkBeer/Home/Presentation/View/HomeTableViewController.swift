//
//  ViewController.swift
//  PunkBeer
//
//  Created by MacDD02 on 07/07/17.
//  Copyright © 2017 darlandev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeProtocol: class {
    var searchBarTextObservable: Observable<String?> {get}
    func setVisibilityActivityIndicator(isVisible: Bool)
    func reloadTableView()
}

class HomeTableViewController: UITableViewController {
    
    var presenter: HomePresenterProtocol!
    
    var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!


    var refreshCtrl: UIRefreshControl!
    
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        
        self.refreshCtrl = UIRefreshControl()
        self.refreshCtrl.addTarget(self, action: #selector(HomeTableViewController.reloadTableView), for: .valueChanged)
        self.refreshControl = self.refreshCtrl
        
        
        self.cache = NSCache()
        
        self.navigationItem.title = "Punk Beer"
        searchBar.textColor = UIColor.white
        configureActivityIndicator()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       configTableView()
    }
    
    private func configureActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
    }
    
    private func configTableView(){
        self.tableView.backgroundColor = UIColor.darkGray
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func sendToDetail(beer: Beer){
        presenter.didSelectArticle(beer)
    }
    
    func setImageBeer(cell:BeerCell, indexPath:IndexPath){
        cell.imageUrl.image = UIImage(named: "placeholder")
        
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
            
            cell.imageUrl.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        }else{
            
            let artworkUrl = presenter.getItem(indexPath: indexPath)?.image!
            let url:URL! = URL(string: artworkUrl!)
            
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    // 4
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        let img:UIImage! = UIImage(data: data)
                        cell.imageUrl.image = img
                        self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                    })
                }
            })
            task.resume()
        }
    }
}

extension HomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath) as! BeerCell
        if let repository = presenter.getItem(indexPath: indexPath) {
            cell.populate(with: repository)
            setImageBeer(cell: cell, indexPath: indexPath)
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beer = presenter.getItem(indexPath: indexPath)
        
        if let myBeer = beer {
            let beerCell =  tableView.cellForRow(at: indexPath) as! BeerCell
            myBeer.beerImage = beerCell.imageUrl
            sendToDetail(beer: myBeer)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension HomeTableViewController: HomeProtocol, UISearchBarDelegate {
    
    var searchBarTextObservable: Observable<String?> {
        return searchBar.rx.text.asObservable()
    }
    
    func setVisibilityActivityIndicator(isVisible: Bool) {
        activityIndicator.isHidden = !isVisible
        if isVisible {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func reloadTableView(){
        tableView.reloadData()
    }
}

extension UISearchBar {
    
    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                textField.textColor = newValue
            }
        }
    }
}

