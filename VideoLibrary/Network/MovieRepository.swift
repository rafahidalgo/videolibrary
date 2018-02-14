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
    
    init()
    
    func discoverMovies(completionHandler: @escaping (JSON?, Error?) -> ())
    func getPopularMovies()
    func getTopRatedMovies()
    func moviesReleaseDateAsc()
    
    func getPosterImage(poster: String) -> URL?
}
