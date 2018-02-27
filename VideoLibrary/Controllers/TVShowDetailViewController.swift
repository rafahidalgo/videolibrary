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
                                                backdropPath: response["backdrop_path"].string!, genres: response["genres"].array!, numberOfSeasons: response["number_of_seasons"].int!,
                                                episodes: response["number_of_episodes"].int!, seasons: response["seasons"].array)
                
                self.name.text = showDetail.name
                self.background.layer.cornerRadius = 10.0
                
                if let backdropImage =  showDetail.backdropPath {
                    
                    let image = self.repository.getBackdropImage(backdrop: backdropImage)
                    self.background.image = image
                }
                else {
                    
                    self.background.image = UIImage(named: "No Image")
                }
                
                self.puntuation.setProgress(value: CGFloat(showDetail.vote), animationDuration: 2.0)
                self.numberSeasons.text = "Seasons: \(showDetail.numberOfSeasons)"
                
                if showDetail.overview.count != 0 {
                    
                    self.overview.text = showDetail.overview
                }
                else {
                    self.overview.textAlignment = .center
                    self.overview.text = "Information not available"
                }
                
                if showDetail.genres.count != 0 {
                    
                    var nombres = ""
                    
                    for item in showDetail.genres {
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
