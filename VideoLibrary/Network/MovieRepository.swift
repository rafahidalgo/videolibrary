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
    
    //Movies
    func discoverMovies(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPopularMovies(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getTopRatedMovies(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func moviesReleaseDateAsc(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    
    //TV Shows
    func discoverTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPopularTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getTopRatedTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getOnAirTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    
    //People
    func discoverPeople(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPerson(name: String, page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPersonDetail(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    
    //Resources
    func getPosterImage(poster: String, view: UIImageView)

}
