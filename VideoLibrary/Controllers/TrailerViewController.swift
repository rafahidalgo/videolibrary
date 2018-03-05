//
//  TrailerViewController.swift
//  VideoLibrary
//
//  Created by MIMO on 3/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var id: Int?
    var videoUrl: String?
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTrailer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func closeModal(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func getTrailer() {
        
        repository.getMovieTrailer(id: id!) { responseObject, error in
            
            if let response = responseObject {
                
                //Puede haber trailer o no, lo comprobamos
                if response["results"].count == 0 {
                    
                    self.utils.showAlertWithCustomMessage(title: "Not trailer available", message: "This film does not currently have a trailer", view: self)
                    self.dismiss(animated: true, completion: nil)
                    
                }
                else {

                    let videoKey = response["results"].arrayValue[0]["key"]
                    
                    let videoUrl = NSLocalizedString("trailerUrl", comment: "URL base de un trailer")+videoKey.string!
                    
                    if let url = URL(string: videoUrl) {
                        self.webView.load(URLRequest(url: url))
                    }
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
}
