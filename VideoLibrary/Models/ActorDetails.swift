//
//  ActorDetails.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation

class ActorDetails: Actor {
    
    let biography: String?
    let birthday: String?
    let deathday: String?
    let placeOfBirth: String?
    let popularity: Int?
    let movie: [Movie]?
    let tvShow: [TVShow]?
    
    public init(id: Int, name: String, photoURL: String?, biography: String?, birthday: String?, deathday: String?, placeOfBirth: String?, popularity: Int?, movie: [Movie]?, tvShow: [TVShow]?){
        
        self.biography = biography
        self.birthday = birthday
        self.deathday = deathday
        self.placeOfBirth = placeOfBirth
        self.popularity = popularity
        self.movie = movie
        self.tvShow = tvShow
        super.init(id: id, name: name, photoURL: photoURL)

    }
}
