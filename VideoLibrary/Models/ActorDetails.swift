//
//  ActorDetails.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation

class ActorDetails: Actor {
    
    var biography: String?
    
    public init(name:String, photo:URL?, biography:String?){
        super.init(name: name, photo: photo)
        self.biography = biography
    }
}
