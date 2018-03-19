//
//  MovieViewCell.swift
//  VideoLibrary
//
//  Created by MIMO on 15/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit
import UICircularProgressRing

class MovieViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRelease: UILabel!
    @IBOutlet weak var voteAverage: UICircularProgressRingView!
    @IBOutlet weak var favoriteButton: UIButton!
    
}
