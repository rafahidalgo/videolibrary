//
//  TVShowViewCell.swift
//  VideoLibrary
//
//  Created by MIMO on 20/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit
import UICircularProgressRing

class TVShowViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tvPoster: UIImageView!
    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var showAirDate: UILabel!
    @IBOutlet weak var voteAverage: UICircularProgressRingView!
}
