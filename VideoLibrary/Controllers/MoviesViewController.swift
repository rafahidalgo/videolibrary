
import UIKit
import SwiftyJSON

class MoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {//TODO crear protocolo comun
    
    @IBOutlet weak var collectionView: UICollectionView!
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var movies: [Movie] = []
    var page: Int = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //TODO conexion internet
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)

        repository.discoverMovies(){ responseObject, error in
            
            self.saveDataToModel(data: responseObject, error: error)
            self.utils.stopLoadingIndicator(indicator: indicator)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieViewCell
        
        cell.movieTitle.text = movies[indexPath.row].title
        cell.voteAverage.setProgress(value: CGFloat(movies[indexPath.row].vote), animationDuration: 0)
        cell.movieRelease.text = movies[indexPath.row].release
        if let poster = movies[indexPath.row].posterUrl {
            repository.getPosterImage(poster: poster, view: cell.moviePoster)
        }
        else {
            //TODO no image da null
            
        }
        
        return utils.styleCardMoviesAndTVShows(cell: cell)

    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        //TODO revisar para pagina
        let options = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        let discover = UIAlertAction(title: "Discover movies", style: .default, handler: { (UIAlertAction) in
            
            let indicator = self.utils.showLoadingIndicator(title: "Loading...", view: self.view)
            self.repository.discoverMovies(){ responseObject, error in
                
                self.resetContent()
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                
            }
            
        })
        
        let popular = UIAlertAction(title: "Popular movies", style: .default, handler: { (UIAlertAction) in
            
            let indicator = self.utils.showLoadingIndicator(title: "Loading...", view: self.view)
            self.repository.getPopularMovies(){ responseObject, error in
            
                self.resetContent()
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                
            }
        })
        
        let top = UIAlertAction(title: "Top rated", style: .default) { (alert: UIAlertAction) in
            
            let indicator = self.utils.showLoadingIndicator(title: "Loading...", view: self.view)
            self.repository.getTopRatedMovies() { responseObject, error in
                
                self.resetContent()
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                
            }
        }
        
        let release = UIAlertAction(title: "Release date (asc)", style: .default) { (alert: UIAlertAction) in
            
            let indicator = self.utils.showLoadingIndicator(title: "Loading...", view: self.view)
            self.repository.moviesReleaseDateAsc() { responseObject, error in
                
               self.resetContent()
               self.saveDataToModel(data: responseObject, error: error)
               self.utils.stopLoadingIndicator(indicator: indicator)
                
            }
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction) in
            
        }
        
        options.addAction(discover)
        options.addAction(popular)
        options.addAction(top)
        options.addAction(release)
        options.addAction(cancel)
        
        //Crash del action sheet en tablets https://stackoverflow.com/questions/31577140/uialertcontroller-is-crashed-ipad/31577494
        if let popover = options.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 1.0, height: 1.0)
        }
        
        self.present(options, animated: true, completion: nil)
    }
    
    func saveDataToModel(data: JSON?, error: Error?) {
        
        if let response = data {
            
            for item in response["results"] {
                let movie = Movie(id: item.1["id"].int!, title: item.1["title"].string!, posterUrl: item.1["poster_path"].string,
                                  vote: item.1["vote_average"].float!, release: item.1["release_date"].string!, overview: item.1["overview"].string!)
                self.movies.append(movie)
            }
            
            self.collectionView.reloadData()
            
            return
        }
        
        print("\(String(describing: error))")//TODO cuadro de dialogo
    }
    
    func resetContent() {
        
        page = 1
        movies.removeAll()
    }
    
}
