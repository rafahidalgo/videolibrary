//
//  Actor.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation

class Actor {
    
    let name: String
    var photoURL: String? //puede que el actor no tenga foto
    
    public init(name: String, photoURL: String?){
        self.name = name
        self.photoURL = photoURL
    }
    
}
