
import UIKit
import SwiftyJSON

class TVShowsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var tvShows: [TVShow] = []
    var page = 1
    var filter = FilterShows.discover

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        repository.discoverTVShows(page: page){ responseObject, error in
            
            if let response = responseObject {
                
                for item in response["results"] {
                    let show = TVShow(id: item.1["id"].int!, name: item.1["name"].string!, posterUrl: item.1["poster_path"].string,
                                      vote: item.1["vote_average"].float!, first_air: item.1["first_air_date"].string!, overview: item.1["overview"].string!)
                    self.tvShows.append(show)
                }
                
                self.collectionView.reloadData()
                
                return
            }
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
        
        cell.showName.text = tvShows[indexPath.row].name
        cell.voteAverage.setProgress(value: CGFloat(tvShows[indexPath.row].vote), animationDuration: 0)
        cell.showAirDate.text = tvShows[indexPath.row].first_air
        cell.tvPoster.layer.cornerRadius = 10.0
        if let poster = tvShows[indexPath.row].posterUrl {
            repository.getPosterImage(poster: poster, view: cell.tvPoster)
        }
        else {
            //TODO no image da null
            
        }
        
        return utils.customCardMoviesAndTVShows(cell: cell)
        
    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == tvShows.count - 1 {
            page += 1
            repository.discoverTVShows(page: page){ responseObject, error in
                
                if let response = responseObject {
                    
                    for item in response["results"] {
                        let show = TVShow(id: item.1["id"].int!, name: item.1["name"].string!, posterUrl: item.1["poster_path"].string,
                                          vote: item.1["vote_average"].float!, first_air: item.1["first_air_date"].string!, overview: item.1["overview"].string!)
                        self.tvShows.append(show)
                    }
                    
                    self.collectionView.reloadData()
                    
                    return
                }
            }
        }
    }
    
    func resetContent() {
        page = 1
        tvShows.removeAll()
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
}
