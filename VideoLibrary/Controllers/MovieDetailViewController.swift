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
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMovieDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getMovieDetails() {
        repository.getMovie(id: id!) {responseObject, error in
            print(responseObject)
        }
    }
}
