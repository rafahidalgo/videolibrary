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
    var backDropUrl: String {get}
    
    init()
    
    //Movies
    func discoverMovies(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPopularMovies(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getTopRatedMovies(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func moviesReleaseDateAsc(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func searchMovie(page: Int, query: String, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getMovie(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    
    //TV Shows
    func discoverTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPopularTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getTopRatedTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getOnAirTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func searchTVShow(page: Int, query: String, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getTVShow(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    
    //People
    func discoverPeople(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPerson(name: String, page: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getPersonDetail(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    func getMovieCredits(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ())
    
    //Resources
    func getPosterImage(poster: String) -> UIImage?
    func getBackdropImage(backdrop: String) -> UIImage?
    
    //Checkings
    func checkResponseCode(response: DataResponse<Any>) -> (JSON?, NSError?)

}
