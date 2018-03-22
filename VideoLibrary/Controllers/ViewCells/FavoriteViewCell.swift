//
//  FavoriteViewCell.swift
//  VideoLibrary
//
//  Created by MIMO on 12/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit
import UICircularProgressRing

class FavoriteViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var voteAverage: UICircularProgressRingView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.formatCell()
    }
    
}

//Formato de las celdas
extension FavoriteViewCell {
    func formatCell() {
        
        //Tamaño del título
        let nameFont = self.name.font.withSize(self.name.bounds.height/1.5)
        self.name.font = nameFont
        
        //Tamaño del círculo de votación
        let heigthAverageView = self.voteAverage.bounds.height
        let ringFont = self.voteAverage.font.withSize(heigthAverageView/3)
        self.voteAverage.font = ringFont
        self.voteAverage.innerRingWidth = heigthAverageView / 8
        self.voteAverage.outerRingWidth = heigthAverageView / 6
    }
}
