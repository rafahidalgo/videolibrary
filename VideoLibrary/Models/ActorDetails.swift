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
    
    public init(id: Int, name: String, photoURL: String?, biography: String?, birthday: String?, deathday: String?, placeOfBirth: String?){
        
        self.biography = biography
        self.birthday = birthday
        self.deathday = deathday
        self.placeOfBirth = placeOfBirth        
        super.init(id: id, name: name, photoURL: photoURL)

    }
}
