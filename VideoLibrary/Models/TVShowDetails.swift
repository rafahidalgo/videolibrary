//
//  TVShowDetails.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation

class TVShowDetails: TVShow {
    
    let backdropPath: String?
    let overview: String
    let genres: [String]
    let numberOfSeasons: Int
    
    init(id: Int, name: String, posterUrl: String?, vote: Float, first_air: String, backdropPath: String?, overview: String,
                                                    genres: [String], numberOfSeasons: Int) {
        
        self.backdropPath = backdropPath
        self.overview = overview
        self.genres = genres
        self.numberOfSeasons = numberOfSeasons
        super.init(id: id, name: name, posterUrl: posterUrl, vote: vote, first_air: first_air)
    }
}
