//
//  BeerCell.swift
//  PunkBeer
//
//  Created by MacDD02 on 07/07/17.
//  Copyright © 2017 darlandev. All rights reserved.
//
import UIKit

class BeerCell: UITableViewCell {
    
    @IBOutlet weak var imageUrl: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var abv: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(with repository: Beer) {
        
        if let nameBeer = repository.name {
            name.text = nameBeer
        }
        
        if let abvBeer = repository.abv {
            abv.text = "\(abvBeer)%"
        }
    }
    
}
