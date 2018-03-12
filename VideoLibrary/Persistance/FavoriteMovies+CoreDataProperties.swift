//
//  FavoriteMovies+CoreDataProperties.swift
//  VideoLibrary
//
//  Created by MIMO on 10/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import CoreData

extension FavoriteMovies {
    
    @NSManaged var id: NSNumber?
    @NSManaged var movieName: String?
    @NSManaged var posterUrl: String?
}
