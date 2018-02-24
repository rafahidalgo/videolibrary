//
//  MovieDetailViewController.swift
//  VideoLibrary
//
//  Created by MIMO on 21/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit
import UICircularProgressRing

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var id: Int?
    var movieDetail: MovieDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMovieDetails {
            self.background.layer.cornerRadius = 10.0
            let backdropImage = self.repository.getBackdropImage(backdrop: (self.movieDetail?.backdropPath)!)//TODO puede que no haya imagen
            self.background.image = backdropImage
            self.movieTitle.text = self.movieDetail?.title
        }
    }
    
    func getMovieDetails(completionHandler: @escaping (() -> ())) {
    
        repository.getMovie(id: id!) {responseObject, error in
            
            if let response = responseObject {
                
                self.movieDetail = MovieDetails(id: response["id"].int!, title: response["title"].string!, posterUrl: response["poster_path"].string,
                                                vote: response["vote_average"].float!, release: response["release_date"].string!, overview: response["overview"].string!,
                                                backdrop: response["backdrop_path"].string!, genres: response["genres"].array, countries: response["production_countries"].array)
                completionHandler()
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
