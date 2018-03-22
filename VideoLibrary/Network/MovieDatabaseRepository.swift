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
    
    let apiUrl = "https://api.themoviedb.org/3/"
    let apiKey = "592d2665d929bc693a5ef6ece254bf2a"
    let posterUrl = "https://image.tmdb.org/t/p/w500"
    let backDropUrl = "https://image.tmdb.org/t/p/w1280"
    let trailerUrl = "https://www.youtube.com/watch?v="
    
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// RUTAS DE PELÍCULAS ////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func discoverMovies(page:Int, completionHandler: @escaping ([OMMovie]?, NSError?, Int?) -> ()) {

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
                
                if let datos = result.0 {
                    
                    var movies: [OMMovie] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        let movie = OMMovie(id: item.1["id"].intValue, title: item.1["title"].stringValue, posterUrl: item.1["poster_path"].string,
                                            vote: item.1["vote_average"].floatValue, releaseDate: item.1["release_date"].stringValue)
                        
                        movies.append(movie)
                    }
                    completionHandler(movies, result.1, total_pages)
                }
                else {

                    completionHandler(nil, result.1, nil)
                }
            }
        )
        
    }
    
    func getPopularMovies(page: Int, completionHandler: @escaping ([OMMovie]?, NSError?, Int?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)movie/popular",
            method: .get,
            parameters: ["api_key":self.apiKey, "language":"es-ES", "page":page])
            .responseJSON { (response) in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var movies: [OMMovie] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        let movie = OMMovie(id: item.1["id"].intValue, title: item.1["title"].stringValue, posterUrl: item.1["poster_path"].string,
                                            vote: item.1["vote_average"].floatValue, releaseDate: item.1["release_date"].stringValue)
                        
                        movies.append(movie)
                    }
                    completionHandler(movies, nil, total_pages)
                }
                else {
                    completionHandler(nil, result.1, nil)
                }
        }
    }
    
    func getTopRatedMovies(page: Int, completionHandler: @escaping ([OMMovie]?, NSError?, Int?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)movie/top_rated",
            method: .get,
            parameters: ["api_key":self.apiKey, "language":"es-ES", "page":page])
            .responseJSON { (response) in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var movies: [OMMovie] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        let movie = OMMovie(id: item.1["id"].intValue, title: item.1["title"].stringValue, posterUrl: item.1["poster_path"].string,
                                            vote: item.1["vote_average"].floatValue, releaseDate: item.1["release_date"].stringValue)
                        
                        movies.append(movie)
                    }
                    completionHandler(movies, nil, total_pages)
                }
                else {
                    completionHandler(nil, result.1, nil)
                }
        }
    }
    
    func moviesReleaseDateAsc(page: Int, completionHandler: @escaping ([OMMovie]?, NSError?, Int?) -> ()) {
        
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
                
                if let datos = result.0 {
                    
                    var movies: [OMMovie] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        let movie = OMMovie(id: item.1["id"].intValue, title: item.1["title"].stringValue, posterUrl: item.1["poster_path"].string,
                                            vote: item.1["vote_average"].floatValue, releaseDate: item.1["release_date"].stringValue)
                        
                        movies.append(movie)
                    }
                    completionHandler(movies, nil, total_pages)
                }
                else {
                    completionHandler(nil, result.1, nil)
                }
            }
        )
    }
    
    func searchMovie(page: Int, query: String, completionHandler: @escaping ([OMMovie]?, NSError?, Int?) -> ()) {

        Alamofire.request("\(self.apiUrl)search/movie",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "query": query,
                         "page":page,
                         "include_adult":"false"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var movies: [OMMovie] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        let movie = OMMovie(id: item.1["id"].intValue, title: item.1["title"].stringValue, posterUrl: item.1["poster_path"].string,
                                            vote: item.1["vote_average"].floatValue, releaseDate: item.1["release_date"].stringValue)
                        
                        movies.append(movie)
                    }
                    completionHandler(movies, nil, total_pages)
                }
                else {
                    completionHandler(nil, result.1, nil)
                }
            }
        )
    }
    
    func getMovie(id: Int, completionHandler: @escaping (OMMovieDetails?, NSError?) -> ()) {//https://stackoverflow.com/questions/27102666/how-to-parse-string-array-with-swiftyjson
        
        Alamofire.request("\(self.apiUrl)movie/\(id)",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    let movieDetail = OMMovieDetails(id: datos["id"].intValue, title: datos["title"].stringValue, posterUrl: datos["poster_path"].stringValue,
                                                     vote: datos["vote_average"].floatValue, releaseDate: datos["release_date"].stringValue, backDropPath: datos["backdrop_path"].string,
                                                     overview: datos["overview"].stringValue, genres: datos["genres"].arrayValue.map{$0["name"].stringValue})
                    
                    completionHandler(movieDetail, result.1) //en este caso result.1 es nulo ya que no hay error
                }
                else {
                    
                    completionHandler(nil, result.1)
                }
            }
        )
    }
    
    func getMovieCast(id: Int, completionHandler: @escaping ([RHActor]?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)movie/\(id)/credits",
            method: .get,
            parameters: ["api_key":self.apiKey])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var cast: [RHActor] = []
                    
                    for item in datos["cast"] {
                        
                        let actor = RHActor(id: item.1["id"].int!, name: item.1["name"].string!, photoURL: item.1["profile_path"].string)
                        cast.append(actor)
                    }
                    
                    completionHandler(cast, result.1)
                }
                else {
                    
                    completionHandler(nil, result.1)
                }
            }
        )
    }
    
    func getMovieTrailer(id: Int, completionHandler: @escaping (String?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)movie/\(id)/videos",
            method: .get,
            parameters: ["api_key":self.apiKey,
            "language":"es-ES"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    //Puede haber trailer o no, lo comprobamos
                    if datos["results"].count == 0 {

                        completionHandler("", nil)// si no hay trailer el API devuelve un array vacio
                    }
                    
                    else {
                        let videoKey = datos["results"].arrayValue[0]["key"]
                        
                        let videoUrl = "\(self.trailerUrl)\(videoKey)"
                        
                        completionHandler(videoUrl, result.1)
                    }
                }
                else {
                    completionHandler(nil, result.1)
                }
            }
        )
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// RUTAS DE SERIES //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func discoverTVShows(page: Int, completionHandler: @escaping ([OMTVShow]?, NSError?, Int?) -> ()) {
        
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
                
                if let datos = result.0 {
                    
                    var shows: [OMTVShow] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        let show = OMTVShow(id: item.1["id"].intValue, name: item.1["name"].stringValue, posterUrl: item.1["poster_path"].string,
                                            vote: item.1["vote_average"].floatValue, firstAir: item.1["first_air_date"].stringValue)
                        
                        shows.append(show)
                    }
                    completionHandler(shows, nil, total_pages)
                }
                else {
                    completionHandler(nil, result.1, nil)
                }
            }
        )
    }
    
    func getPopularTVShows(page: Int, completionHandler: @escaping ([OMTVShow]?, NSError?, Int?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)tv/popular",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "page":page])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var shows: [OMTVShow] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        let show = OMTVShow(id: item.1["id"].intValue, name: item.1["name"].stringValue, posterUrl: item.1["poster_path"].string,
                                            vote: item.1["vote_average"].floatValue, firstAir: item.1["first_air_date"].stringValue)
                        
                        shows.append(show)
                    }
                    completionHandler(shows, nil, total_pages)
                }
                else {
                    completionHandler(nil, result.1, nil)
                }
            }
        )
    }
    
    func getTopRatedTVShows(page: Int, completionHandler: @escaping ([OMTVShow]?, NSError?, Int?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)tv/top_rated",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "page":page])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var shows: [OMTVShow] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        let show = OMTVShow(id: item.1["id"].intValue, name: item.1["name"].stringValue, posterUrl: item.1["poster_path"].string,
                                            vote: item.1["vote_average"].floatValue, firstAir: item.1["first_air_date"].stringValue)
                        
                        shows.append(show)
                    }
                    completionHandler(shows, nil, total_pages)
                }
                else {
                    completionHandler(nil, result.1, nil)
                }
            }
        )
    }
    
    func getOnAirTVShows(page: Int, completionHandler: @escaping ([OMTVShow]?, NSError?, Int?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)tv/on_the_air",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var shows: [OMTVShow] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        let show = OMTVShow(id: item.1["id"].intValue, name: item.1["name"].stringValue, posterUrl: item.1["poster_path"].string,
                                            vote: item.1["vote_average"].floatValue, firstAir: item.1["first_air_date"].stringValue)
                        
                        shows.append(show)
                    }
                    completionHandler(shows, nil, total_pages)
                }
                else {
                    completionHandler(nil, result.1, nil)
                }
            }
        )
    }
    
    func searchTVShow(page: Int, query: String, completionHandler: @escaping ([OMTVShow]?, NSError?, Int?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)search/tv",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES",
                         "query": query,
                         "page":page])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var shows: [OMTVShow] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        let show = OMTVShow(id: item.1["id"].intValue, name: item.1["name"].stringValue, posterUrl: item.1["poster_path"].string,
                                            vote: item.1["vote_average"].floatValue, firstAir: item.1["first_air_date"].stringValue)
                        
                        shows.append(show)
                    }
                    completionHandler(shows, nil, total_pages)
                }
                else {
                    completionHandler(nil, result.1, nil)
                }
            }
        )
    }
    
    func getTVShow(id: Int, completionHandler: @escaping (OMTVShowDetails?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)tv/\(id)",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    let showDetail = OMTVShowDetails(id: datos["id"].intValue, name: datos["name"].stringValue, posterUrl: datos["poster_path"].string,
                                                     vote: datos["vote_average"].floatValue, firstAir: datos["first_air_date"].stringValue, backDropPath: datos["backdrop_path"].stringValue,
                                                     overview: datos["overview"].stringValue, genres: datos["genres"].arrayValue.map{$0["name"].stringValue}, seasons: datos["number_of_seasons"].intValue)
                    
                    completionHandler(showDetail, result.1)
                }
                else {
                    
                    completionHandler(nil, result.1)
                }
            }
        )
    }
    
    func getTVShowCast(id: Int, completionHandler: @escaping ([RHActor]?, NSError?) -> ()) {
        
        Alamofire.request("\(self.apiUrl)tv/\(id)/credits",
            method: .get,
            parameters: ["api_key":self.apiKey,
                         "language":"es-ES"])
            .responseJSON(completionHandler: {response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var cast: [RHActor] = []
                    
                    for item in datos["cast"] {
                        
                        let actor = RHActor(id: item.1["id"].int!, name: item.1["name"].string!, photoURL: item.1["profile_path"].string)
                        cast.append(actor)
                    }
                    
                    completionHandler(cast, result.1)
                }
                else {
                    
                    completionHandler(nil, result.1)
                }
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
    
    func discoverPeople(page: Int, completionHandler: @escaping ([RHActor]?, NSError?, Int?) -> ()) {

        Alamofire.request("\(self.apiUrl)person/popular",
            method: .get,
            parameters: ["api_key": self.apiKey,
                         "language": "es-ES",
                         "page": page])
            .responseJSON { response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var people: [RHActor] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        if let name = item.1["name"].string {
                            let id = item.1["id"].int!
                            if let photo = item.1["profile_path"].string {
                                let actor = RHActor(id: id, name: name, photoURL: photo)
                                people.append(actor)
                            }
                            else {
                                let actor = RHActor(id: id, name: name, photoURL: nil)
                                people.append(actor)
                            }
                        }
                        
                    }
                    completionHandler(people, nil, total_pages)
                }
                else {
                    completionHandler(nil, result.1, nil)
                }
        }
    }
    

    func getPerson(name: String, page: Int, completionHandler: @escaping ([RHActor]?, NSError?, Int?) -> ()) {
        Alamofire.request("\(self.apiUrl)search/person",
            method: .get,
            parameters: ["api_key": self.apiKey,
                         "language": "es-ES",
                         "query": name,
                         "page": page])
            .responseJSON { response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var people: [RHActor] = []
                    let total_pages = datos["total_pages"].intValue
                    
                    for item in datos["results"] {
                        
                        if let name = item.1["name"].string {
                            let id = item.1["id"].int!
                            if let photo = item.1["profile_path"].string {
                                let actor = RHActor(id: id, name: name, photoURL: photo)
                                people.append(actor)
                            }
                            else {
                                let actor = RHActor(id: id, name: name, photoURL: nil)
                                people.append(actor)
                            }
                        }
                    }
                    completionHandler(people, nil, total_pages)
                }
                else {
                    completionHandler(nil, result.1, nil)
                }
        }
    }
    
    func getPersonDetail(id: Int, completionHandler: @escaping (RHActorDetails?, NSError?) -> ()) {
        Alamofire.request("\(self.apiUrl)person/\(id)",
            method: .get,
            parameters: ["api_key": self.apiKey,
                         "language": "es-ES"])
            .responseJSON { response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    let name = datos["name"].string ?? nil
                    let photo = datos["profile_path"].string ?? nil
                    var biography = datos["biography"].string ?? nil
                    if biography == "" {
                        biography = "The biography is not available in the requested language"
                    }
                    let birthday = datos["birthday"].string ?? "-"
                    let deathday = datos["deathday"].string ?? "-"
                    let placeOfBirth = datos["place_of_birth"].string ?? "-"
                    let person = RHActorDetails(id: id, name: name!, photoURL: photo, biography: biography, birthday: birthday, deathday: deathday, placeOfBirth: placeOfBirth)
                    
                    completionHandler(person, result.1)
                }
                else {
                    completionHandler(nil, result.1)
                }
            }
    }
    
    func getMovieCredits(id: Int, completionHandler: @escaping ([OMMovie]?, NSError?) -> ()) {
        Alamofire.request("\(self.apiUrl)person/\(id)/movie_credits",
            method: .get,
            parameters: ["api_key": self.apiKey,
                         "language": "es-ES"])
            .responseJSON { response in
                
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var credits: [OMMovie] = []
                    
                    for movie in datos["cast"] {
                        let id = movie.1["id"].int!
                        let title = movie.1["title"].string!
                        let posterUrl = movie.1["poster_path"].string ?? nil
                        let movie = OMMovie(id: id, title: title, posterUrl: posterUrl, vote: 0, releaseDate: "")
                        credits.append(movie)
                    }
                    
                    completionHandler(credits, result.1)
                }
                else {
                    completionHandler(nil, result.1)
                }
        }
    }
    
    func getTVShowCredits(id: Int, completionHandler: @escaping ([OMTVShow]?, NSError?) -> ()) {
        Alamofire.request("\(self.apiUrl)person/\(id)/tv_credits",
            method: .get,
            parameters: ["api_key": self.apiKey,
                         "language": "es-ES"])
            .responseJSON { response in
                let result = self.checkResponseCode(response: response)
                
                if let datos = result.0 {
                    
                    var credits: [OMTVShow] = []
                    
                    for show in datos["cast"] {
                        let id = show.1["id"].int!
                        let name = show.1["name"].string!
                        let posterUrl = show.1["poster_path"].string ?? nil
                        let show = OMTVShow(id: id, name: name, posterUrl: posterUrl, vote: 0, firstAir: "")
                        credits.append(show)
                    }
                    
                    completionHandler(credits, result.1)
                }
                else {
                    completionHandler(nil, result.1)
                }
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
