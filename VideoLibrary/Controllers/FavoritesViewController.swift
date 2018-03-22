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

        addNotificationObserver()
        
        getFavoriteMovies()
        
        //Formateamos la celda
        self.sizeFavoriteCell(widthScreen: view.bounds.width)
        
    }
    
    //Se formatea la celda en cada cambio de orientación
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.sizeFavoriteCell(widthScreen: size.width)
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



//Notificaciones locales
extension FavoritesViewController {
    
    func addNotificationObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNotification(notification:)), name: Notification.Name(notificationKeyFavorites), object: nil)
    }
    
    @objc func setNotification(notification: NSNotification) {

        //Cuando llega la notificacion vaciamos el array correspondiente para cargar los datos actualizados
        switch segment.selectedSegmentIndex {
        case 0:
            userMovies.removeAll()
            getFavoriteMovies()
        default:
            userShows.removeAll()
            getFavoriteShows()
        }
        collectionView.reloadData()
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
                
                self.userMovies.remove(at: (indexPath?.row)!)
                NotificationCenter.default.post(name: Notification.Name(notificationKeyMovies), object: nil)
            }
        default:
            
            guard let cell = sender.superview?.superview as? FavoriteViewCell else {
                utils.showAlertWithCustomMessage(title: "Error", message: NSLocalizedString("favoriteError", comment: ""), view: self)
                return
            }
            
            let indexPath = collectionView.indexPath(for: cell)
            if self.favorite.deleteFavoriteShow(id: userShows[(indexPath?.row)!].id as! Int) {
                
                self.userShows.remove(at: (indexPath?.row)!)
                NotificationCenter.default.post(name: Notification.Name(notificationKeyShows), object: nil)
            }
        }
        self.collectionView.reloadData()
    }
    
}

//Formato de las celdas
extension FavoritesViewController {
    func sizeFavoriteCell(widthScreen: CGFloat) {
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            //Horizontal -> 2 columnas   Vertical -> 1 columna
            //Si la pantalla del iphone es inferior a 568 puntos siempre habrá una columna
            let landscape = UIDevice.current.orientation.isLandscape
            let itemsPerRow: CGFloat = landscape && widthScreen > 568 ? 2 : 1
            let padding: CGFloat = 10
            //Si está en horizontal y solo hay una columna (pantalla < 568) el ancho de la celda será el 60%
            let utilWidth = landscape && itemsPerRow == 1 ? widthScreen * 0.6 : widthScreen - padding * (itemsPerRow * 2)
            let itemWidth = utilWidth / itemsPerRow
            let itemHeight = itemWidth * (2/5)
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding)
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            collectionView.collectionViewLayout = layout
        } else if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            //Horizontal -> 3 columnas   Vertical -> 2 columnas
            let landscape = UIDevice.current.orientation.isLandscape
            let itemsPerRow: CGFloat = landscape ? 3 : 2
            let padding: CGFloat = 10
            let utilWidth = widthScreen - padding * (itemsPerRow * 2)
            let itemWidth = utilWidth / itemsPerRow
            let itemHeight = itemWidth * (2/5)
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding)
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            collectionView.collectionViewLayout = layout
        }
        
    }
}



