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
    
    func discoverMovies(completionHandler: @escaping (JSON?, Error?) -> ())
    func getPopularMovies(completionHandler: @escaping (JSON?, Error?) -> ())
    func getTopRatedMovies(completionHandler: @escaping (JSON?, Error?) -> ())
    func moviesReleaseDateAsc(completionHandler: @escaping (JSON?, Error?) -> ())
    func getPosterImage(poster: String, view: UIImageView)
    func discoverPeople(completionHandler: @escaping (JSON?, Error?) -> ())

}
