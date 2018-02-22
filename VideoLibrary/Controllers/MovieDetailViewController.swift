//
//  MovieDetailViewController.swift
//  VideoLibrary
//
//  Created by MIMO on 21/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMovieDetails {() -> () in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getMovieDetails(completionHandler:@escaping (() -> ())) {
        repository.getMovie(id: id!) {responseObject, error in
            
            if let response = responseObject {
                
                for item in response["results"] {
                    let movie = MovieDetails(id: item.1["id"].int!, title: item.1["title"].string!, posterUrl: item.1["poster_path"].string,
                                      vote: item.1["vote_average"].float!, release: item.1["release_date"].string!, overview: item.1["overview"].string!,
                                      backdrop: item.1["backdrop_path"].string!, genres: item.1["genres"].array, countries: item.1["production_countries"].array)
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
}
