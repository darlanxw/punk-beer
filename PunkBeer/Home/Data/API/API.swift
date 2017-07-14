//
//  API.swift
//  PunkBeer
//
//  Created by MacDD02 on 07/07/17.
//  Copyright © 2017 darlandev. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import AlamofireObjectMapper

struct punk {
    static let baseUrl = "https://api.punkapi.com/v2/beers"
}

protocol Endpoint {
    var path: String { get }
    var url: String { get }
}

enum Endpoints {
    
    enum Beers: Endpoint {
        case fetchWithPath
        case fetch
        public var path: String {
            switch self {
            case .fetchWithPath: return "?beer_name="
            case .fetch: break
            }
            return ""
        }
        
        public var url: String {
            switch self {
            case .fetchWithPath: return "\(punk.baseUrl)\(path)"
            case .fetch: return "\(punk.baseUrl)"
            }
        }
    }
}

class API {
    static func getBeers(byName name: String?) -> Observable<[Beer]> {
        var url:String = ""
        
        if  let searchName = name {
            url = "\(Endpoints.Beers.fetchWithPath.url)\( searchName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        }else{
            url = Endpoints.Beers.fetch.url
        }
        
        
        return Observable<[Beer]>.create { observer -> Disposable in
            let request = Alamofire
                .request(url)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[Beer]>) in
                    switch response.result {
                    case .success(let articles):
                        observer.onNext(articles)
                        observer.onCompleted()
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
}
