
import UIKit

class TVShowsViewController: UIViewController {

    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var tvShows: [TVShow] = []
    var page: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        
    }
    
}
