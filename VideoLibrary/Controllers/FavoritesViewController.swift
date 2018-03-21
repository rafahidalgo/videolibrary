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



//CollectionView
extension FavoritesViewController {
    
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
            cell.voteAverage.setProgress(value: CGFloat(truncating: userMovies[indexPath.row].movieVotes!), animationDuration: 0)
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
            cell.voteAverage.setProgress(value: CGFloat(truncating: userShows[indexPath.row].showVotes!), animationDuration: 0)
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
}



//Obtención de datos
extension FavoritesViewController {
    
    func getFavoriteMovies() {
        
        guard let favoriteMovies = favorite.checkFavoritesMovies() else {
            return
        }
        
        userMovies = favoriteMovies
    }
    
    func getFavoriteShows() {
        
        guard let favoriteShows = favorite.checkFavoritesShows() else {
            return
        }
        
        userShows = favoriteShows
    }
}



//Ver los detalles de un elemento y eliminarlo de la lista de favoritos
extension FavoritesViewController {
    
    /*Como los detalles pueden llevar a dos viewcontrollers diferentes
    los llamo por código en vez de desde el storyboard.*/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
    @IBAction func removeFromFavorites(_ sender: UIButton) {
        
        switch self.segment.selectedSegmentIndex {
        case 0:
            
            guard let cell = sender.superview?.superview as? FavoriteViewCell else {
                utils.showAlertWithCustomMessage(title: "Error", message: NSLocalizedString("favoriteError", comment: ""), view: self)
                return
            }
            
            let indexPath = collectionView.indexPath(for: cell)
            if self.favorite.deleteFavoriteMovie(id: userMovies[(indexPath?.row)!].id as! Int) {
                
                cell.favoriteButton.setImage(UIImage(named: "No favorite"), for: .normal)
                self.userMovies.remove(at: (indexPath?.row)!)
            }
        default:
            
            guard let cell = sender.superview?.superview as? FavoriteViewCell else {
                utils.showAlertWithCustomMessage(title: "Error", message: NSLocalizedString("favoriteError", comment: ""), view: self)
                return
            }
            
            let indexPath = collectionView.indexPath(for: cell)
            if self.favorite.deleteFavoriteShow(id: userShows[(indexPath?.row)!].id as! Int) {
                
                cell.favoriteButton.setImage(UIImage(named: "No favorite"), for: .normal)
                self.userShows.remove(at: (indexPath?.row)!)
            }
        }
        self.collectionView.reloadData()
    }
    
}
