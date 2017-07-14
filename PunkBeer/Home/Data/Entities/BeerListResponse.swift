//
//  BeerListResponse.swift
//  PunkBeer
//
//  Created by MacDD02 on 07/07/17.
//  Copyright © 2017 darlandev. All rights reserved.
//

import ObjectMapper

class BeerListResponse: Mappable {
    
    var totalCount: Int?
    var repositories: [Beer]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        repositories <- map["result"]
    }
}
