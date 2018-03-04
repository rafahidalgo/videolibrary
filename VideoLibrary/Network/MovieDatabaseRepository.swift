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
    let backDropUrl: String
    
    init() {
        
        self.apiUrl = "https://api.themoviedb.org/3/"
        self.apiKey = "592d2665d929bc693a5ef6ece254bf2a"
        self.posterUrl = "https://image.tmdb.org/t/p/w500"
        self.backDropUrl = "https://image.tmdb.org/t/p/w1280"

    }
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// RUTAS DE PELÍCULAS ////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func discoverMovies(page:Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {

        Alamofire.request("\(self.apiUrl)\("discover/movie")",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "sort_by":"popularity.desc",
                         "include_adult":"false",
                         "include_video":"false",
                         "page":page])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
        
    }
    
    func getPopularMovies(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)movie/popular",
            method: .get,
            parameters: ["api_key":self.apiKey, "language":"es-ES", "page":page])
            .responseJSON { (response) in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
        }
    }
    
    func getTopRatedMovies(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)movie/top_rated",
            method: .get,
            parameters: ["api_key":self.apiKey, "language":"es-ES", "page":page])
            .responseJSON { (response) in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
        }
    }
    
    func moviesReleaseDateAsc(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)discover/movie",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "sort_by":"release_date.asc",
                         "include_adult":"false",
                         "include_video":"false",
                         "page":page])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
    func searchMovie(page: Int, query: String, completionHandler: @escaping (JSON?, NSError?) -> ()) {

        Alamofire.request("\(self.apiUrl)search/movie",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "query": query,
                         "page":page,
                         "include_adult":"false"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
    func getMovie(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)movie/\(id)",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
    func getMovieCast(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)movie/\(id)/credits",
            method: .get,
            parameters: ["api_key":self.apiKey])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
    func getMovieTrailer(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)movie/\(id)/videos",
            method: .get,
            parameters: ["api_key":self.apiKey,
            "language":"es-ES"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// RUTAS DE SERIES //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func discoverTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)discover/tv",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "sort_by":"popularity.desc",
                          "page":page,
                         "timezone":"Europe/Madrid",
                         "include_null_first_air_dates":"false"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
    func getPopularTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)tv/popular",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "page":page])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
    func getTopRatedTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)tv/top_rated",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "page":page])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
    func getOnAirTVShows(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)tv/on_the_air",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
    func searchTVShow(page: Int, query: String, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)search/tv",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "query": query,
                         "page":page])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
    func getTVShow(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)tv/\(id)",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
    func getTVShowCast(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)tv/\(id)/credits",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
        )
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// RUTAS DE IMÁGENES ////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func getPosterImage(poster: String) -> UIImage? {
        
        let url = URL(string: "\(self.posterUrl)\(poster)")
        let posterImage: UIImage?
        
        if let data = try? Data(contentsOf: url!) {
            
            posterImage = UIImage(data: data)
            posterImage?.af_inflate()
        }
        else {
            posterImage = UIImage(named: "No image")
        }
        
        return posterImage
    }
    
    func getBackdropImage(backdrop: String) -> UIImage?{
        
        let url = URL(string: "\(self.backDropUrl)\(backdrop)")
        let backdropImage: UIImage?
        
        if let data = try? Data(contentsOf: url!) {
            
            backdropImage = UIImage(data: data)
            backdropImage?.af_inflate()
        }
        else {
            backdropImage = UIImage(named: "No image")
        }
        
        return backdropImage
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// RUTAS DE ACTORES /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func discoverPeople(page: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {

        Alamofire.request("\(self.apiUrl)person/popular",
            method: .get,
            parameters: ["api_key": self.apiKey,
                         "language": "es-ES",
                         "page": page])
            .responseJSON { response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
        }
    }
    

    func getPerson(name: String, page: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        Alamofire.request("\(self.apiUrl)search/person",
            method: .get,
            parameters: ["api_key": self.apiKey,
                         "language": "es-ES",
                         "query": name,
                         "page": page])
            .responseJSON { response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
        }
    }
    
    func getPersonDetail(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        Alamofire.request("\(self.apiUrl)person/\(id)",
            method: .get,
            parameters: ["api_key": self.apiKey,
                         "language": "es-ES"])
            .responseJSON { response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
            }
    }
    
    func getMovieCredits(id: Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        Alamofire.request("\(self.apiUrl)person/\(id)/movie_credits",
            method: .get,
            parameters: ["api_key": self.apiKey,
                         "language": "es-ES"])
            .responseJSON { response in
                
                let result = self.checkResponseCode(response: response)
                completionHandler(result.0, result.1)
        }
    }
    
    func checkResponseCode(response: DataResponse<Any>) -> (JSON? , NSError?){
        
        switch response.result {
            
            case .success(let data):
                let json = JSON(data)
                let code = (response.response?.statusCode)! as Int
                
                switch code {
                    case 200:
                        return (json, nil)
                    default:
                        let error = NSError(domain: json["status_message"].string!, code: code, userInfo: nil)
                        return (nil, error)
                }
            
            case .failure(let error as NSError)://internet lost
                return (nil, error)
        }
    }

}
