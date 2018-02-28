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
        
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)
        
        //Hay que hacer dos peticiones, una para obtener los detalles de una película y otra para el cast de actores.
        //Con el siguiente código se busca que primero se obtengan los detalles de la película y cuando esten almacenados y listos para usar
        //se obtiene el cast de actores. Si por algún motivo falla la conexión a internet al entrar en la vista de detalles de una película
        //no se realizará la closure de getMovieDetails.
        getMovieDetails(id: id!) {() -> () in

            self.getMovieCredits(id: self.id!) {() -> () in
                self.collectionCast.reloadData()
                self.utils.stopLoadingIndicator(indicator: indicator)
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
        
        cell.castImage.layer.cornerRadius = 10.0
        cell.actorName.text = cast[indexPath.row].name
        
        return utils.customCardMoviesAndTVShows(cell: cell)
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
                    
                    let actor = Actor(id: item.1["id"].int!, name: item.1["name"].string!, photoURL: item.1["profile_path"].string)
                    self.cast.append(actor)
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
    
    @IBAction func showTrailer(_ sender: UIButton) {
        
    }
    
    @IBAction func addMovie(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! CastViewCell
        let indexPath = collectionCast.indexPath(for: cell)
        let detailViewController = segue.destination as! PeopleDetailViewController
        detailViewController.id = cast[(indexPath?.row)!].id
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
