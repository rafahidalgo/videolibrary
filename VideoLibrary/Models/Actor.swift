//
//  Actor.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation

class Actor {
    
    let id: Int
    let name: String
    var photoURL: String?
    
    public init(id: Int, name: String, photoURL: String?){
        self.id = id
        self.name = name
        self.photoURL = photoURL
    }
    
}
