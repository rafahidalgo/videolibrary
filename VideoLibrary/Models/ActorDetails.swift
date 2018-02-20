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
    let birthday: Date?
    let placeOfBirth: String?
    let movie: [Movie]?
    let tvShow: [TVShow]?
    
    public init(id: Int, name: String, photoURL: String?, biography: String?, birthday: Date?, placeOfBirth: String?, movie: [Movie]?, tvShow: [TVShow]?){
        
        self.biography = biography
        self.birthday = birthday
        self.placeOfBirth = placeOfBirth
        self.movie = movie
        self.tvShow = tvShow
        super.init(id: id, name: name, photoURL: photoURL)

    }
}
