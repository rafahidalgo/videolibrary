//
//  MovieDetails.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation

class MovieDetails: Movie {
    
    let backdropPath: String?
    let genres: [String]
    let countries: [String]
    
    init(id: Int, title: String, posterUrl: String?, vote: Float, release: String, overview: String, backdrop: String?, genres: [String], countries: [String]) {
        self.backdropPath = backdrop
        self.genres = genres
        self.countries = countries
        super.init(id: id, title: title, posterUrl: posterUrl, vote: vote, release: release, overview: overview)
    }
}
