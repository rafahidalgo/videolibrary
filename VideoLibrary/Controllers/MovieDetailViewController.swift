//
//  MovieDetailViewController.swift
//  VideoLibrary
//
//  Created by MIMO on 21/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var id: Int?
    var movieDetail: MovieDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repository.getMovie(id: id!) {responseObject, error in
            
            if let response = responseObject {
                
                self.movieDetail = MovieDetails(id: response["id"].int!, title: response["title"].string!, posterUrl: response["poster_path"].string,
                                         vote: response["vote_average"].float!, release: response["release_date"].string!, overview: response["overview"].string!,
                                         backdrop: response["backdrop_path"].string!, genres: response["genres"].array, countries: response["production_countries"].array)
                self.background.layer.cornerRadius = 10.0
                self.repository.getBackdropImage(backdrop: (self.movieDetail?.backdropPath)!, imageView: self.background)//TODO puede que no haya imagen
                self.movieTitle.text = self.movieDetail?.title
                return
            }
            
            if (error?.code)! < 0 {
                self.utils.showAlertConnectionLost(view: self)
            }
            else {
                self.utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
