//
//  FavoritesViewController.swift
//  VideoLibrary
//
//  Created by MIMO on 12/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit
import FloatingActionSheetController

class FavoritesViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    let favorite = Favorites()
    let utils = Utils()
    let repository = MovieDatabaseRepository()
    var userMovies: [FavoriteMovies] = []
    var userShows: [FavoriteTVShows] = []
    
    //Podría usarse el mismo array para guardar las películas y las series favoritas pero al cambiar de página en el segment habría que vaciar el array y
    //volver a pedir los datos a Core Data.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        getFavoriteMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch segment.selectedSegmentIndex {
            case 0:
                return userMovies.count
            default:
                return userShows.count
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteViewCell
        
        cell.posterImage.layer.cornerRadius = 10.0
        
        if segment.selectedSegmentIndex == 0 {
            
            cell.name.text = userMovies[indexPath.row].movieName
            if let poster = userMovies[indexPath.row].posterUrl {
                let posterImage = repository.getPosterImage(poster: poster)
                cell.posterImage.image = posterImage
            }
            else {
                cell.posterImage.image = UIImage(named: "No Image")
            }
        }
        else {
            
            cell.name.text = userShows[indexPath.row].tvShowName
            if let poster = userShows[indexPath.row].posterUrl {
                let posterImage = repository.getPosterImage(poster: poster)
                cell.posterImage.image = posterImage
            }
            else {
                cell.posterImage.image = UIImage(named: "No Image")
            }
        }
        
        return utils.customCardMoviesAndTVShows(cell: cell)
    }
    
    func getFavoriteMovies() {
        
        guard let favoriteMovies = favorite.checkFavoritesMovies() else {
            utils.showAlertWithCustomMessage(title: "No favorite movies", message: NSLocalizedString("noFavoriteMovies", comment: ""), view: self)
            return
        }
        
        userMovies = favoriteMovies
    }
    
    func getFavoriteShows() {
        
        guard let favoriteShows = favorite.checkFavoritesShows() else {
            utils.showAlertWithCustomMessage(title: "No favorite tv shows", message: NSLocalizedString("noFavoriteShows", comment: ""), view: self)
            return
        }
        
        userShows = favoriteShows
    }

    @IBAction func changeContent(_ sender: UISegmentedControl) {
        
        switch segment.selectedSegmentIndex {
            case 0:
                if userMovies.count == 0 {
                    getFavoriteMovies()
                }
            default:
                if userShows.count == 0 {
                    getFavoriteShows()
                }
            }
        
        collectionView.reloadData()
    }
    
    @IBAction func closeFavorites(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension FavoritesViewController {
    
    /*Cuando se selecciona un elemento de favoritos se lanza esta función que muestra un action sheet con las opciones de
    borrar el elemento de favoritos o ver sus detalles. Como los detalles pueden llevar a dos viewcontrollers diferentes
    los llamo por código en vez de desde el storyboard.*/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let view = FloatingAction(title: NSLocalizedString("viewDetails", comment: "")) { action in //Ver detalles
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            switch self.segment.selectedSegmentIndex {
                case 0:

                    if let movieDetail = storyBoard.instantiateViewController(withIdentifier: "Movie Detail") as? MovieDetailViewController {
                        movieDetail.id = self.userMovies[indexPath.row].id as? Int
                        self.navigationController?.pushViewController(movieDetail, animated: true)
                    }
                default:
                    
                    if let tvShowDetail = storyBoard.instantiateViewController(withIdentifier: "TVShow Detail") as? TVShowDetailViewController {
                        tvShowDetail.id = self.userShows[indexPath.row].id as? Int
                        self.navigationController?.pushViewController(tvShowDetail, animated: true)
                    }
            }
        }
        
        let delete = FloatingAction(title: NSLocalizedString("deleteFavorite", comment: "")) {action in //Borrar de favoritos
            
            switch self.segment.selectedSegmentIndex {
                case 0:
                    if self.favorite.deleteFavoriteMovie(id: self.userMovies[indexPath.row].id as! Int) {
                        self.userMovies.remove(at: indexPath.row)
                    }
                default:
                    if self.favorite.deleteFavoriteShow(id: self.userShows[indexPath.row].id as! Int) {
                        self.userShows.remove(at: indexPath.row)
                    }
            }
            self.collectionView.reloadData()
        }
        
        let group = FloatingActionGroup(action: view, delete)
        let actionSheet = FloatingActionSheetController(actionGroup: group).present(in: self)
        actionSheet.animationStyle = .pop
    }
}
