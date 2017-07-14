//
//  File.swift
//  PunkBeer
//
//  Created by MacDD02 on 13/07/17.
//  Copyright © 2017 darlandev. All rights reserved.
//

import Foundation
import UIKit

class DetailRouter {
    
    static func assembleModule(_ beer: Beer) -> UIViewController {
        let view = R.storyboard.main.detailTableViewController()
        view?.beer = beer
        
        return view!
    }
}
