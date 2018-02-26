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
    @IBOutlet weak var overview: UILabel!
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var id: Int?
    var showDetail: TVShowDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getShowdetails {
            self.background.layer.cornerRadius = 10.0
            let backdropImage = self.repository.getBackdropImage(backdrop: (self.showDetail?.backdropPath)!)//TODO puede que no haya imagen
            self.background.image = backdropImage
            self.name.text = self.showDetail?.name
            self.puntuation.setProgress(value: CGFloat((self.showDetail?.vote)!), animationDuration: 2.0)
            //self.overview.text = self.showDetail?.overview
        }
    }
    
    func getShowdetails(completionHandler: @escaping (() -> ())) {
        
        repository.getTVShow(id: id!) {responseObject, error in
            
            if let response = responseObject {
                
                self.showDetail = TVShowDetails(id: response["id"].int!, name: response["name"].string!, posterUrl: response["poster_path"].string,
                                                vote: response["vote_average"].float!, first_air: response["first_air_date"].string!, overview: response["overview"].string!,
                                                backdropPath: response["backdrop_path"].string!, genres: response["genres"].array, numberOfSeasons: response["number_of_seasons"].int!,
                                                episodes: response["number_of_episodes"].int!, seasons: response["seasons"].array)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
