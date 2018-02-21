
import UIKit
import SwiftyJSON

class MoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {//TODO crear protocolo comun
    
    @IBOutlet weak var collectionView: UICollectionView!
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var movies: [Movie] = []
    var page = 1
    var content = FilterMovies.discover
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        getData()
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
        cell.moviePoster.layer.cornerRadius = 10.0
        if let poster = movies[indexPath.row].posterUrl {
            repository.getPosterImage(poster: poster, view: cell.moviePoster)
        }
        else {
            cell.moviePoster.image = UIImage(named: "No Image")
        }
        
        return utils.customCardMoviesAndTVShows(cell: cell)

    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {

        let options = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        let discover = UIAlertAction(title: "Discover movies", style: .default, handler: { (UIAlertAction) in

            self.resetContent()
            self.content = .discover
            self.getData()
            
        })
        
        let popular = UIAlertAction(title: "Popular movies", style: .default, handler: { (UIAlertAction) in
            
            self.resetContent()
            self.content = .popular
            self.getData()
        })
        
        let top = UIAlertAction(title: "Top rated", style: .default) { (alert: UIAlertAction) in
            
            self.resetContent()
            self.content = .top_rated
            self.getData()
        }
        
        let release = UIAlertAction(title: "Release date (asc)", style: .default) { (alert: UIAlertAction) in
            
            self.resetContent()
            self.content = .release_date
            self.getData()
            
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
    
    @IBAction func addFavoriteMovie(_ sender: UIButton) {
        
    }
    
    //Scroll infinito
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            page += 1
            getData()
        }
    }
    
    func getData() {
        
        //La vista de películas puede mostrar los datos filtrados por diversos criterios (películas populares, mejor valoradas,...) por lo que cuando un usuario
        //realiza scroll en la pantalla debe conocerse qué criterio está fijado para cargar los datos de la página correspondiente
        //de una dirección u otra. Una manera de hacer esto es mediante una variable, en este caso content, que almacena la opción seleccionada y
        //en función de su valor se obtienen los datos correspondientes.
        
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)
        switch content {
            case .discover:
                repository.discoverMovies(page: page){ responseObject, error in
                    
                    self.saveDataToModel(data: responseObject, error: error)
                    self.utils.stopLoadingIndicator(indicator: indicator)
            }
            case .popular:
                repository.getPopularMovies(page: page){ responseObject, error in
                    
                    self.saveDataToModel(data: responseObject, error: error)
                    self.utils.stopLoadingIndicator(indicator: indicator)
            }
            case .top_rated:
                repository.getTopRatedMovies(page: page) { responseObject, error in
                    
                    self.saveDataToModel(data: responseObject, error: error)
                    self.utils.stopLoadingIndicator(indicator: indicator)
            }
            default:
                repository.moviesReleaseDateAsc(page: page) { responseObject, error in
                    
                    self.saveDataToModel(data: responseObject, error: error)
                    self.utils.stopLoadingIndicator(indicator: indicator)
            }
        }
    }
    
    //Esta función recorre el objeto JSON que tiene la información de las películas y almacena estos datos en el modelo
    func saveDataToModel(data: JSON?, error: NSError?) {

        if let response = data {
            
            for item in response["results"] {
                let movie = Movie(id: item.1["id"].int!, title: item.1["title"].string!, posterUrl: item.1["poster_path"].string,
                                  vote: item.1["vote_average"].float!, release: item.1["release_date"].string!, overview: item.1["overview"].string!)
                self.movies.append(movie)
            }
            
            self.collectionView.reloadData()
            
            return
        }
        
        if (error?.code)! < 0 {
            utils.showAlertConnectionLost(view: self)
        }
        else {
            utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self)
        }

    }
    
    func resetContent() {
        page = 1
        movies.removeAll()
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
}
