//
//  TVShowDetailViewController.swift
//  VideoLibrary
//
//  Created by MIMO on 23/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit
import UICircularProgressRing

class TVShowDetailViewController: UIViewController {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var puntuation: UICircularProgressRingView!
    @IBOutlet weak var numberSeasons: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var genres: UILabel!
    
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getShowdetails(id: id!)
    }
    
    func getShowdetails(id: Int) {
        
        repository.getTVShow(id: id) {responseObject, error in
            
            if let response = responseObject {
                
                let showDetail = TVShowDetails(id: response["id"].int!, name: response["name"].string!, posterUrl: response["poster_path"].string,
                                                vote: response["vote_average"].float!, first_air: response["first_air_date"].string!, overview: response["overview"].string!,
                                                backdropPath: response["backdrop_path"].string!, genres: response["genres"].array, numberOfSeasons: response["number_of_seasons"].int!,
                                                episodes: response["number_of_episodes"].int!, seasons: response["seasons"].array)
                self.background.layer.cornerRadius = 10.0
                let backdropImage = self.repository.getBackdropImage(backdrop: (showDetail.backdropPath)!)//TODO puede que no haya imagen
                self.background.image = backdropImage
                self.name.text = showDetail.name
                self.puntuation.setProgress(value: CGFloat(showDetail.vote), animationDuration: 2.0)
                self.numberSeasons.text = "Seasons: \(showDetail.numberOfSeasons)"
                self.overview.text = showDetail.overview
                
                if let generos = showDetail.genres {
                    
                    var nombres = ""
                    
                    for item in generos {
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
    
    @IBAction func addTVShow(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
