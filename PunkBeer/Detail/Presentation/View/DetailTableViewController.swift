//
//  DetailTableViewController.swift
//  PunkBeer
//
//  Created by MacDD02 on 13/07/17.
//  Copyright © 2017 darlandev. All rights reserved.
//

import Foundation
import UIKit

class DetailTableViewController : UITableViewController {
    @IBOutlet var imageViewBeer: UIImageView!
    @IBOutlet var name:UILabel!
    @IBOutlet var tagline:UILabel!
    @IBOutlet var ibu:UILabel!
    @IBOutlet var descriptionBeer: UITextView!
    @IBOutlet var abv: UILabel!
    
    var beer:Beer!
    var image:UIImageView!
    
    override func viewDidLoad() {
        self.navigationItem.title = beer.name
        imageViewBeer.image =  beer.beerImage!.image!
        name.text = beer.name
        tagline.text = beer.tagline
        ibu.text = "\(beer.ibu!)%"
        abv.text = "\(beer.abv!)%"
        descriptionBeer.text = beer.descriptionBeer
    }
}
