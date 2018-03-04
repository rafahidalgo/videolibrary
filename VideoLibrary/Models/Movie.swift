//
//  Movie.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation

class Movie {
    
    let id: Int
    let title: String
    let posterUrl: String?
    let vote: Float
    let release: String
    
    init(id:Int, title:String, posterUrl: String?, vote: Float, release: String) {
        self.id = id
        self.title = title
        self.posterUrl = posterUrl
        self.vote = vote
        self.release = release
    }
}
