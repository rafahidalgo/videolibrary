//
//  MovieRepository.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol MovieRepository {
    
    var apiUrl: String {get}
    var apiKey: String {get}
    var posterUrl: String {get}
    
    init()
    
    func discoverMovies(completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPopularMovies(completionHandler: @escaping (JSON?, NSError?) -> ())
    func getTopRatedMovies(completionHandler: @escaping (JSON?, NSError?) -> ())
    func moviesReleaseDateAsc(completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPosterImage(poster: String, view: UIImageView)
    func discoverPeople(completionHandler: @escaping (JSON?, NSError?) -> ())

}
