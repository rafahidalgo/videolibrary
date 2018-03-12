//
//  FavoriteTVShows+CoreDataProperties.swift
//  VideoLibrary
//
//  Created by MIMO on 11/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import CoreData

extension FavoriteTVShows {
    
    @NSManaged var id: NSNumber?
    @NSManaged var tvShowName: String?
    @NSManaged var posterUrl: String?
}
