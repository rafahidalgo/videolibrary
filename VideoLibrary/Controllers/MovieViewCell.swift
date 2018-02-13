//
//  MovieViewCell.swift
//  VideoLibrary
//
//  Created by MIMO on 13/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit

class MovieViewCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
