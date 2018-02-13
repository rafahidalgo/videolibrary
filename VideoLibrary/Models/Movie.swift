//
//  Movie.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation

class Movie {
    
    let title: String
    let posterUrl: String?
    
    init(title:String, posterUrl: String?) {
        self.title = title
        self.posterUrl = posterUrl
    }
}
