//
//  MovieDatabaseRepository.swift
//  VideoLibrary
//
//  Created by MIMO on 12/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import Alamofire
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
    
    func discoverMovies(completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)\("discover/movie")",
            method: .get,
            parameters: ["api_key":self.apiKey, "language":"es-ES",
                         "sort_by":"popularity.desc", "include_adult":"false", "include_video":"false", "page":"1"])
            .responseJSON(completionHandler: {response in
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json, nil)
                    return
                }
                let error = response.result.error
                completionHandler(nil, error)
            }
        )
        
    }
    
    func getPopularMovies() {
        
        Alamofire.request("\(self.apiUrl)\("movie/popular")",
            method: .get,
            parameters: ["api_key":self.apiKey, "language":"es-ES", "page":"1"])
            .responseJSON { (response) in
                print(response)
        }
    }
    
    func getTopRatedMovies() {
        
    }
    
    func moviesReleaseDateAsc() {
        
    }
    
    func getPosterImage(poster: String) -> URL? {
        
        let url = URL(string: "\(self.posterUrl)\(poster)")
        return url
        
    }
    
}
