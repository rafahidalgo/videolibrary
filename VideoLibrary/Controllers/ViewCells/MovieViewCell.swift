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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.formatCell()
    }
    
}

//Formato de las celdas
extension MovieViewCell {
    func formatCell() {        
        //Tamaño del título
        let titleFont = self.movieTitle.font.withSize(self.movieTitle.bounds.height/1.5)
        self.movieTitle.font = titleFont
        
        //Tamaño de la fecha de estreno
        let releaseFont = self.movieRelease.font.withSize(self.movieRelease.bounds.height/2.5)
        self.movieRelease.font = releaseFont
        
        //Tamaño del círculo de votación
        let heigthAverageView = self.voteAverage.bounds.height
        let ringFont = self.voteAverage.font.withSize(heigthAverageView/3)
        self.voteAverage.font = ringFont
        self.voteAverage.innerRingWidth = heigthAverageView / 8
        self.voteAverage.outerRingWidth = heigthAverageView / 6
    }
}
