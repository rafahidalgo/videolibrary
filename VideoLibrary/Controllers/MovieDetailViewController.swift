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
    @IBOutlet weak var favoriteButton: UIButton!
    
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var id: Int? //Identificador de la película pasado por parámetro al segue
    var movieDetail = OMMovieDetails()
    let favorite = Favorites()
    var cast: [RHActor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionCast.delegate = self
        collectionCast.dataSource = self
        
        let indicator = utils.showLoadingIndicator(title: NSLocalizedString("loading", comment: ""), view: view)
        
        //Hay que hacer dos peticiones, una para obtener los detalles de una película y otra para el cast de actores.
        //Con el siguiente código se busca que primero se obtengan los detalles de la película y cuando esten almacenados y listos para usar
        //se obtiene el cast de actores. Si por algún motivo falla la conexión a internet al entrar en la vista de detalles de una película
        //no se realizará la closure de getMovieDetails.
        getMovieDetails(id: id!) { () -> () in

            self.getMovieCredits(id: self.id!) {[weak self] () -> () in
                self?.collectionCast.reloadData()
                self?.utils.stopLoadingIndicator(indicator: indicator)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



//Obtención de los datos de una película y del cast
extension MovieDetailViewController {
    
    func getMovieDetails(id: Int, completionHandler:@escaping (() -> ())) { 
        
        repository.getMovie(id: id) {responseObject, error in
            
            if let response = responseObject {
                
                self.movieDetail = response //asignamos los detalles de la película al objeto OMMovieDetails de esta clase
                
                self.movieTitle.text = self.movieDetail.title
                self.background.layer.cornerRadius = 10.0
                
                if let backdropImage =  self.movieDetail.backDropPath {
                    
                    let image = self.repository.getBackdropImage(backdrop: backdropImage)
                    self.background.image = image
                }
                else {
                    
                    self.background.image = UIImage(named: "No Image")
                }
                
                self.puntuation.setProgress(value: CGFloat((self.movieDetail.vote)), animationDuration: 2.0)
                
                if self.movieDetail.overview.count != 0 {
                    
                    self.overview.text = self.movieDetail.overview
                }
                else {
                    self.overview.textAlignment = .center
                    self.overview.text = NSLocalizedString("notAvailable", comment: "Mensaje que informa de que los datos no están disponibles")
                }
                
                if self.movieDetail.genres?.count != 0 {
                    
                    var nombres = ""
                    
                    for item in (self.movieDetail.genres)! {
                        nombres += item as! String + " "
                    }
                    self.genres.text = nombres
                }
                else {
                    self.genres.text = NSLocalizedString("notAvailable", comment: "Mensaje que informa de que los datos no están disponibles")
                }
                
                //Comprobamos si la película está en favoritos
                if self.favorite.searchMovie(id: id) != nil {
                    
                    self.favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
                }
                else {
                    
                    self.favoriteButton.setImage(UIImage(named: "No favorite green"), for: .normal)
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
                
                self.cast = response //asignamos el cast de la película
                
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
}



//CollectionView que muestra el cast de una película
extension MovieDetailViewController {
    
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
}



//Añadir película a favoritos
extension MovieDetailViewController {
    
    @IBAction func addMovie(_ sender: UIButton) {
        
        if favorite.searchMovie(id: movieDetail.id) != nil && favorite.deleteFavoriteMovie(id: movieDetail.id) {
            
            favoriteButton.setImage(UIImage(named: "No favorite green"), for: .normal)
            utils.showToast(message: NSLocalizedString("movieDeleted", comment: ""), view: view)
            
        }
        else {
            
            if favorite.addFavoriteMovie(id: movieDetail.id, title: movieDetail.title, image: movieDetail.posterUrl, vote: movieDetail.vote) {
                
                favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
                utils.showToast(message: NSLocalizedString("movieAdded", comment: ""), view: view)
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(notificationKeyMovies), object: nil)
        NotificationCenter.default.post(name: Notification.Name(notificationKeyFavorites), object: movieDetail.id)
    }
}



//Trailer de una película
extension MovieDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueID = segue.identifier {
            if segueID == "modalTrailer" {
                
                let detailViewController = segue.destination as! TrailerViewController
                detailViewController.id = self.id
            }
            
        }
        else {
            let cell = sender as! CastViewCell
            let indexPath = collectionCast.indexPath(for: cell)
            let detailViewController = segue.destination as! PeopleDetailViewController
            detailViewController.id = cast[(indexPath?.row)!].id
        }
    }
}
