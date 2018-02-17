
import UIKit

class MoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //TODO conexion internet
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)
        //TODO meter esto en una función
        repository.discoverMovies(){ responseObject, error in
            
            if let response = responseObject {
                
                for item in response["results"] {
                    let movie = Movie(id: item.1["id"].int!, title: item.1["title"].string!, posterUrl: item.1["poster_path"].string,
                                      vote: item.1["vote_average"].float!, release: item.1["release_date"].string!, overview: item.1["overview"].string!)
                    self.movies.append(movie)
                }
                
                self.collectionView.reloadData()
                indicator.0.stopAnimating()
                indicator.1.removeFromSuperview()
                
                return
            }
            
            print("\(String(describing: error))")//TODO cuadro de dialogo
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
        cell.movieDescription.text = movies[indexPath.row].overview
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
                if let response = responseObject {
                    
                    self.resetContent()
                    for item in response["results"] {
                        let movie = Movie(id: item.1["id"].int!, title: item.1["title"].string!, posterUrl: item.1["poster_path"].string,
                                          vote: item.1["vote_average"].float!, release: item.1["release_date"].string!, overview: item.1["overview"].string!)
                        self.movies.append(movie)
                    }
                    
                    self.collectionView.reloadData()
                    indicator.0.stopAnimating()
                    indicator.1.removeFromSuperview()
                    
                    return
                }
                
                print("\(String(describing: error))")
            }
            
        })
        
        let popular = UIAlertAction(title: "Popular movies", style: .default, handler: { (UIAlertAction) in
            
            let indicator = self.utils.showLoadingIndicator(title: "Loading...", view: self.view)
            self.repository.getPopularMovies(){ responseObject, error in
            
                if let response = responseObject {
                    
                    self.resetContent()
                    for item in response["results"] {
                        
                        let movie = Movie(id: item.1["id"].int!, title: item.1["title"].string!, posterUrl: item.1["poster_path"].string,
                                          vote: item.1["vote_average"].float!, release: item.1["release_date"].string!, overview: item.1["overview"].string!)
                        self.movies.append(movie)
                    }
                    
                    self.collectionView.reloadData()
                    indicator.0.stopAnimating()
                    indicator.1.removeFromSuperview()
                    
                    return
                
                }
                
                print("\(String(describing: error))")
                
            }
        })
        
        let top = UIAlertAction(title: "Top rated", style: .default) { (alert: UIAlertAction) in
            
            let indicator = self.utils.showLoadingIndicator(title: "Loading...", view: self.view)
            self.repository.getTopRatedMovies() { responseObject, error in
                
                if let response = responseObject {
                    
                    self.resetContent()
                    for item in response["results"] {
                        
                        let movie = Movie(id: item.1["id"].int!, title: item.1["title"].string!, posterUrl: item.1["poster_path"].string,
                                          vote: item.1["vote_average"].float!, release: item.1["release_date"].string!, overview: item.1["overview"].string!)
                        self.movies.append(movie)
                    }
                    
                    self.collectionView.reloadData()
                    indicator.0.stopAnimating()
                    indicator.1.removeFromSuperview()
                    
                    return
                    
                }
                
                print("\(String(describing: error))")
                
            }
        }
        
        let release = UIAlertAction(title: "Release date (asc)", style: .default) { (alert: UIAlertAction) in
            
            let indicator = self.utils.showLoadingIndicator(title: "Loading...", view: self.view)
            self.repository.moviesReleaseDateAsc() {
                
                responseObject, error in
                
                if let response = responseObject {
                    
                    self.resetContent()
                    for item in response["results"] {
                        
                        let movie = Movie(id: item.1["id"].int!, title: item.1["title"].string!, posterUrl: item.1["poster_path"].string,
                                          vote: item.1["vote_average"].float!, release: item.1["release_date"].string!, overview: item.1["overview"].string!)
                        self.movies.append(movie)
                    }
                    
                    self.collectionView.reloadData()
                    indicator.0.stopAnimating()
                    indicator.1.removeFromSuperview()
                    
                    return
                    
                }
                
                print("\(String(describing: error))")
                
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction) in
            
        }
        
        options.addAction(discover)
        options.addAction(popular)
        options.addAction(top)
        options.addAction(release)
        options.addAction(cancel)
        
        self.present(options, animated: true, completion: nil)
    }
    
    func saveMoviesData() {
        
        
    }
    
    func resetContent() {
        //TODO reset página
        movies.removeAll()
    }
    
}
