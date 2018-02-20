
import UIKit

class TVShowsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var tvShows: [TVShow] = []
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        repository.discoverTVShows(page: page){ responseObject, error in
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVShowCell", for: indexPath) as! TVShowViewCell
        
        
        
        return cell
        
    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        
    }
    
}
