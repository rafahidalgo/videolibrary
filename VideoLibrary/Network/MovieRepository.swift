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
    
    
    //Movies
    func discoverMovies(page: Int, completionHandler: @escaping ([OMMovie]?, NSError?, Int?) -> ())
    func getUpcomingMovies(page: Int, completionHandler: @escaping ([OMMovie]?, NSError?, Int?) -> ())
    func getTopRatedMovies(page: Int, completionHandler: @escaping ([OMMovie]?, NSError?, Int?) -> ())
    func moviesReleaseDateAsc(page: Int, completionHandler: @escaping ([OMMovie]?, NSError?, Int?) -> ())
    func searchMovie(page: Int, query: String, completionHandler: @escaping ([OMMovie]?, NSError?, Int?) -> ())
    func getMovie(id: Int, completionHandler: @escaping (OMMovieDetails?, NSError?) -> ())
    func getMovieCast(id: Int, completionHandler: @escaping ([RHActor]?, NSError?) -> ())
    func getMovieTrailer(id: Int, completionHandler: @escaping (String?, NSError?) -> ())
    
    //TV Shows
    func discoverTVShows(page: Int, completionHandler: @escaping ([OMTVShow]?, NSError?, Int?) -> ())
    func getAiringToday(page: Int, completionHandler: @escaping ([OMTVShow]?, NSError?, Int?) -> ())
    func getTopRatedTVShows(page: Int, completionHandler: @escaping ([OMTVShow]?, NSError?, Int?) -> ())
    func getOnAirTVShows(page: Int, completionHandler: @escaping ([OMTVShow]?, NSError?, Int?) -> ())
    func searchTVShow(page: Int, query: String, completionHandler: @escaping ([OMTVShow]?, NSError?, Int?) -> ())
    func getTVShow(id: Int, completionHandler: @escaping (OMTVShowDetails?, NSError?) -> ())
    func getTVShowCast(id: Int, completionHandler: @escaping ([RHActor]?, NSError?) -> ())
    
    //People
    func discoverPeople(page: Int, completionHandler: @escaping ([RHActor]?, NSError?, Int?) -> ())
    func getPerson(name: String, page: Int, completionHandler: @escaping ([RHActor]?, NSError?, Int?) -> ())
    func getPersonDetail(id: Int, completionHandler: @escaping (RHActorDetails?, NSError?) -> ())
    func getMovieCredits(id: Int, completionHandler: @escaping ([OMMovie]?, NSError?) -> ())
    func getTVShowCredits(id: Int, completionHandler: @escaping ([OMTVShow]?, NSError?) -> ())
    
    //Resources
    func getPosterImage(poster: String) -> UIImage?
    func getBackdropImage(backdrop: String) -> UIImage?
    
    //Checkings
    func checkResponseCode(response: DataResponse<Any>) -> (JSON?, NSError?)

}
