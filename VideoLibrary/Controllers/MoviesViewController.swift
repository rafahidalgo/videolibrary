
import UIKit

class MoviesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let api = APICalls()
        api.discoverMovies(){ responseObject, error in
            if let response = responseObject {
                print("\(response)")
                return
            }
            print("\(String(describing: error))")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
