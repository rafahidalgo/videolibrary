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
    @IBOutlet weak var puntuation: UICircularProgressRingView!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var genres: UILabel!
    
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMovieDetails(id: id!)
    }
    
    func getMovieDetails(id: Int) {
    
        repository.getMovie(id: id) {responseObject, error in
            
            if let response = responseObject {
                
                let movieDetail = MovieDetails(id: response["id"].int!, title: response["title"].string!, posterUrl: response["poster_path"].string,
                                                vote: response["vote_average"].float!, release: response["release_date"].string!, overview: response["overview"].string!,
                                                backdrop: response["backdrop_path"].string, genres: response["genres"].array!, countries: response["production_countries"].array)
                
                self.movieTitle.text = movieDetail.title
                self.background.layer.cornerRadius = 10.0
                
                if let backdropImage =  movieDetail.backdropPath {
                    
                    let image = self.repository.getBackdropImage(backdrop: backdropImage)
                    self.background.image = image
                }
                else {

                    self.background.image = UIImage(named: "No Image")
                }
                
                self.puntuation.setProgress(value: CGFloat(movieDetail.vote), animationDuration: 2.0)
                
                if movieDetail.overview.count != 0 {
                    
                    self.overview.text = movieDetail.overview
                }
                else {
                    self.overview.textAlignment = .center
                    self.overview.text = "Information not available"
                }

                if movieDetail.genres.count != 0 {
                    
                    var nombres = ""
                    
                    for item in movieDetail.genres {
                        nombres += " \(item["name"].string!)"
                    }
                    self.genres.text = nombres
                }
                else {
                    self.genres.text = "Information not available"
                }

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
    
    @IBAction func showTrailer(_ sender: UIButton) {
        
    }
    
    @IBAction func addMovie(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
