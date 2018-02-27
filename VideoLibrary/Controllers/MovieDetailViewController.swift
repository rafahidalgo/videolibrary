//
//  MovieDetailViewController.swift
//  VideoLibrary
//
//  Created by MIMO on 21/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit
import UICircularProgressRing
import SwiftyJSON

class MovieDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var puntuation: UICircularProgressRingView!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var collectionCast: UICollectionView!
    
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var id: Int?
    var cast: [Actor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionCast.delegate = self
        collectionCast.dataSource = self
        getMovieDetails(id: id!) {() -> () in
            self.getMovieCredits(id: self.id!) {() -> () in
                
                self.collectionCast.reloadData()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorCell", for: indexPath) as! CastViewCell
    
        if let imageURL = cast[indexPath.row].photoURL {
            let posterImage = repository.getPosterImage(poster: imageURL)
            cell.castImage.image = posterImage
        } else {
            cell.castImage.image = UIImage(named: "No Image")
        }
        
        return cell
    }
    
    func getMovieDetails(id: Int, completionHandler:@escaping (() -> ())) {
    
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
    
    func getMovieCredits(id: Int, completionHandler:@escaping (() -> ())) {
        
        repository.getMovieCast(id: id) { responseObject, error in
            
            if let response = responseObject {
                
                for item in response["cast"] {
                    
                    let actor = Actor(id: item.1["id"].int!, name: item.1["name"].string!, photoURL: item.1["profile_path"].string)//TODO foto
                    self.cast.append(actor)
                }
                
                completionHandler()
                return
            }
            
            if (error?.code)! < 0 {
                self.utils.showAlertConnectionLost(view: self)//TODO forzar error
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
