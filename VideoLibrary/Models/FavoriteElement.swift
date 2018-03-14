//
//  FavoriteElement.swift
//  VideoLibrary
//
//  Created by MIMO on 12/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation

class FavoriteElement {
    
    let id: Int
    let title: String
    let posterUrl: String?
    
    init(id:Int, title:String, posterUrl: String?) {
        self.id = id
        self.title = title
        self.posterUrl = posterUrl
    }
}
