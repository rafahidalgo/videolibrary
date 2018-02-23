//
//  TVShowDetailViewController.swift
//  VideoLibrary
//
//  Created by MIMO on 23/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit

class TVShowDetailViewController: UIViewController {

    @IBOutlet weak var background: UIImageView!
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var id: Int?
    var showDetail: TVShowDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repository.getTVShow(id: id!) {responseObject, error in
            
            if let response = responseObject {
                
                print(response)
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
