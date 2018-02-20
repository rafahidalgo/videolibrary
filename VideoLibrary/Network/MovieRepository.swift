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
    
    func discoverMovies(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPopularMovies(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getTopRatedMovies(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func moviesReleaseDateAsc(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPosterImage(poster: String, view: UIImageView)
    func discoverPeople(page: Int, completionHandler: @escaping (JSON?, Error?) -> ())
    func getPerson(name: String, page: Int, completionHandler: @escaping (JSON?, Error?) -> ())


}
