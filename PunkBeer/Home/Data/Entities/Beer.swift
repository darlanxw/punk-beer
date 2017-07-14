//
//  Beer.swift
//  PunkBeer
//
//  Created by MacDD02 on 07/07/17.
//  Copyright © 2017 darlandev. All rights reserved.
//

import ObjectMapper
import UIKit

class Beer : Mappable{
    var id: Int?
    var name: String?
    var abv: Int?
    var image: String?
    var tagline: String?
    var ibu: Int?
    var descriptionBeer: String?
    var beerImage:UIImageView?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        abv <- map["abv"]
        image <- map["image_url"]
        tagline <- map["tagline"]
        ibu <- map["ibu"]
        descriptionBeer <- map["description"]
    }
}
