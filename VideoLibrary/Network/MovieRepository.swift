//
//  MovieRepository.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import Alamofire
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
    func searchMovie(page: Int, query: String, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getMovie(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    
    func discoverTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPopularTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getTopRatedTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getOnAirTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func searchTVShow(page: Int, query: String, completionHandler: @escaping (JSON?, NSError?) -> ())
    
    func getPosterImage(poster: String, imageView: UIImageView)
    func discoverPeople(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPerson(name: String, page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())

    func checkResponseCode(response: DataResponse<Any>) -> (JSON?, NSError?)
}
