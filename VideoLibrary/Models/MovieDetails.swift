//
//  MovieDetails.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import SwiftyJSON

class MovieDetails: Movie {
    
    let backdropPath: String?
    let overview: String
    let genres: [JSON]
    let countries: [JSON]?
    
    init(id: Int, title: String, posterUrl: String?, vote: Float, release: String, backdrop: String?, overview: String, genres: [JSON], countries: [JSON]?) {
        self.backdropPath = backdrop
        self.overview = overview
        self.genres = genres
        self.countries = countries
        super.init(id: id, title: title, posterUrl: posterUrl, vote: vote, release: release)
    }
}
