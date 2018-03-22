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
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.formatCell()
    }
    
}

//Formato de las celdas
extension TVShowViewCell {
    func formatCell() {
        
        //Tamaño del título
        let nameFont = self.showName.font.withSize(self.showName.bounds.height/1.5)
        self.showName.font = nameFont
        
        //Tamaño de la fecha de estreno
        let dateFont = self.showAirDate.font.withSize(self.showAirDate.bounds.height/2.5)
        self.showAirDate.font = dateFont
        
        //Tamaño del círculo de votación
        let heigthAverageView = self.voteAverage.bounds.height
        let ringFont = self.voteAverage.font.withSize(heigthAverageView/3)
        self.voteAverage.font = ringFont
        self.voteAverage.innerRingWidth = heigthAverageView / 8
        self.voteAverage.outerRingWidth = heigthAverageView / 6
    }
}
