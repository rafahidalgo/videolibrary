//
//  TVShowDetails.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import SwiftyJSON

class TVShowDetails: TVShow {
    
    let backdropPath: String?
    let genres: [JSON]?
    let numberOfSeasons: Int
    let episodes: Int
    let seasons: [JSON]?
    
    init(id: Int, name: String, posterUrl: String?, vote: Float, first_air: String, overview: String, backdropPath: String?
                                                , genres: [JSON]?, numberOfSeasons: Int, episodes: Int, seasons: [JSON]?) {
        self.backdropPath = backdropPath
        self.genres = genres
        self.numberOfSeasons = numberOfSeasons
        self.episodes = episodes
        self.seasons = seasons
        super.init(id: id, name: name, posterUrl: posterUrl, vote: vote, first_air: first_air, overview: overview)
    }
}
