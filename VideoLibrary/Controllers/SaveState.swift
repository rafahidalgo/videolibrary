//
//  SaveState.swift
//  VideoLibrary
//
//  Created by MIMO on 22/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation

class SaveState: NSObject, NSCoding {
    
    var currentState: String
    
    init(currentState: String) {
        self.currentState = currentState
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(currentState, forKey: "state")
    }
    
    required init?(coder aDecoder: NSCoder) {
        currentState = aDecoder.decodeObject(forKey: "state") as! String
    }
}
