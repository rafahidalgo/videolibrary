//
//  TVShowDetailViewController.swift
//  VideoLibrary
//
//  Created by MIMO on 23/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit
import UICircularProgressRing

class TVShowDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var puntuation: UICircularProgressRingView!
    @IBOutlet weak var numberSeasons: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var collectionCast: UICollectionView!
    
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var id: Int?
    var showDetail = OMTVShowDetails()
    var cast: [RHActor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionCast.delegate = self
        collectionCast.dataSource = self
        
        let indicator = utils.showLoadingIndicator(title: NSLocalizedString("loading", comment: ""), view: view)

        //Hay que hacer dos peticiones, una para obtener los detalles de una serie y otra para el cast de actores.
        //Con el siguiente código se busca que primero se obtengan los detalles de la serie y cuando esten almacenados y listos para usar
        //se obtiene el cast de actores. Si por algún motivo falla la conexión a internet al entrar en la vista de detalles de una serie
        //no se realizará la closure de getTVShowDetails.
        getTVShowDetails(id: id!) { () -> () in
            
            self.getTVShowCredits(id: self.id!) {() -> () in
                self.collectionCast.reloadData()
                self.utils.stopLoadingIndicator(indicator: indicator)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}



//Obtención de los detalles de la serie y el cast
extension TVShowDetailViewController {
    
    func getTVShowDetails(id: Int, completionHandler:@escaping (() -> ())) {
        
        repository.getTVShow(id: id) {responseObject, error in
            
            if let response = responseObject {
                
                self.showDetail = response
                
                self.name.text = self.showDetail.name
                self.background.layer.cornerRadius = 10.0
                
                if let backdropImage =  self.showDetail.backdropPath {
                    
                    let image = self.repository.getBackdropImage(backdrop: backdropImage)
                    self.background.image = image
                }
                else {
                    
                    self.background.image = UIImage(named: "No Image")
                }
                
                self.puntuation.setProgress(value: CGFloat(self.showDetail.vote), animationDuration: 2.0)
                self.numberSeasons.text = "Seasons: \(self.showDetail.numberOfSeasons)"
                
                if self.showDetail.overview.count != 0 {
                    
                    self.overview.text = self.showDetail.overview
                }
                else {
                    self.overview.textAlignment = .center
                    self.overview.text = NSLocalizedString("notAvailable", comment: "Mensaje que informa de que los datos no están disponibles")
                }
                
                if self.showDetail.genres?.count != 0 {
                    
                    var nombres = ""
                    
                    for item in (self.showDetail.genres)! {
                        nombres += item as! String + " "
                    }
                    self.genres.text = nombres
                }
                else {
                    self.genres.text = NSLocalizedString("notAvailable", comment: "Mensaje que informa de que los datos no están disponibles")
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
    
    func getTVShowCredits(id: Int, completionHandler:@escaping (() -> ())) {

        repository.getTVShowCast(id: id) { responseObject, error in
            
            if let response = responseObject {

                self.cast = response //asignamos el cast de la serie
                
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



//CollectionView que muestra el cast de la serie
extension TVShowDetailViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! CastViewCell
        
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



//Añadir serie a favoritos
extension TVShowDetailViewController {
    
    @IBAction func addTVShow(_ sender: UIButton) {
        
        let favorite = Favorites()
        
        if favorite.addFavoriteShow(id: showDetail.id, name: showDetail.name, image: showDetail.backdropPath) {
            
            utils.showToast(message: NSLocalizedString("showAdded", comment: ""), view: view)
        }
    }
}



//Ver los detalles de un actor del cast
extension TVShowDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! CastViewCell
        let indexPath = collectionCast.indexPath(for: cell)
        let detailViewController = segue.destination as! PeopleDetailViewController
        detailViewController.id = cast[(indexPath?.row)!].id
    }
}
