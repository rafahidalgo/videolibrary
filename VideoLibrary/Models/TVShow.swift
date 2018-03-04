//
//  TVShow.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation

class TVShow {
    
    let id: Int
    let name: String
    let posterUrl: String?
    let vote: Float
    let first_air: String
    
    init(id:Int, name:String, posterUrl: String?, vote: Float, first_air: String) {
        self.id = id
        self.name = name
        self.posterUrl = posterUrl
        self.vote = vote
        self.first_air = first_air
    }
}
