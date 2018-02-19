//
//  MovieDatabaseRepository.swift
//  VideoLibrary
//
//  Created by MIMO on 12/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

struct MovieDatabaseRepository: MovieRepository {
    
    let apiUrl: String  
    let apiKey: String
    let posterUrl: String
    
    
    init() {
        
        self.apiUrl = "https://api.themoviedb.org/3/"
        self.apiKey = "592d2665d929bc693a5ef6ece254bf2a"
        self.posterUrl = "https://image.tmdb.org/t/p/w500"
        
    }
    
    func discoverMovies(completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)\("discover/movie")",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "sort_by":"popularity.desc",
                         "include_adult":"false",
                         "include_video":"false",
                         "page":"1"])
            .responseJSON(completionHandler: {response in

                switch response.result {
                    
                    case .success(let data):
                        let json = JSON(data)
                        let code = (response.response?.statusCode)! as Int
                        
                        switch code {
                            case 200:
                                completionHandler(json, nil)
                            default:
                                let error = NSError(domain: json["status_message"].string!, code: code, userInfo: nil)
                                completionHandler(nil, error)
                        }
                    
                    case .failure(let error as NSError)://internet lost
                        completionHandler(nil, error)
                }
            }
        )
        
    }
    
    func getPopularMovies(completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)\("movie/popular")",
            method: .get,
            parameters: ["api_key":self.apiKey, "language":"es-ES", "page":"1"])
            .responseJSON { (response) in
                
                switch response.result {
                    
                    case .success(let data):
                        let json = JSON(data)
                        let code = (response.response?.statusCode)! as Int
                    
                    switch code {
                        case 200:
                            completionHandler(json, nil)
                        default:
                            let error = NSError(domain: json["status_message"].string!, code: code, userInfo: nil)
                            completionHandler(nil, error)
                    }
                    
                case .failure(let error as NSError):
                    completionHandler(nil, error)
            }
        }
    }
    
    func getTopRatedMovies(completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)\("movie/top_rated")",
            method: .get,
            parameters: ["api_key":self.apiKey, "language":"es-ES", "page":"1"])
            .responseJSON { (response) in
                
                switch response.result {
                    
                    case .success(let data):
                        let json = JSON(data)
                        let code = (response.response?.statusCode)! as Int
                    
                    switch code {
                        case 200:
                            completionHandler(json, nil)
                        default:
                            let error = NSError(domain: json["status_message"].string!, code: code, userInfo: nil)
                            completionHandler(nil, error)
                    }
                    
                case .failure(let error as NSError):
                    completionHandler(nil, error)
            }
        }
    }
    
    func moviesReleaseDateAsc(completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)\("discover/movie")",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "sort_by":"release_date.asc",
                         "include_adult":"false",
                         "include_video":"false",
                         "page":"1"])
            .responseJSON(completionHandler: {response in
                
                switch response.result {
                    
                    case .success(let data):
                        let json = JSON(data)
                        let code = (response.response?.statusCode)! as Int
                    
                    switch code {
                        case 200:
                            completionHandler(json, nil)
                        default:
                            let error = NSError(domain: json["status_message"].string!, code: code, userInfo: nil)
                            completionHandler(nil, error)
                    }
                    
                case .failure(let error as NSError):
                    completionHandler(nil, error)
                }
            }
        )
    }
    
    func getPosterImage(poster: String, view: UIImageView) {
        
        let url = URL(string: "\(self.posterUrl)\(poster)")
        view.af_setImage(withURL: url!)
        
    }
    
    func discoverPeople(completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)person/popular",
            method: .get,
            parameters: ["api_key": self.apiKey,
                         "language": "es-ES",
                         "page": "1"])
            .responseJSON { response in
                
                switch response.result {
                    
                    case .success(let data):
                        let json = JSON(data)
                        let code = (response.response?.statusCode)! as Int
                    
                    switch code {
                        case 200:
                            completionHandler(json, nil)
                        default:
                            let error = NSError(domain: json["status_message"].string!, code: code, userInfo: nil)
                            completionHandler(nil, error)
                    }
                    
                case .failure(let error as NSError):
                    completionHandler(nil, error)
                }
        }
        
    }
    
}
