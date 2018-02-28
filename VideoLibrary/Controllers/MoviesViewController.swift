
import UIKit
import SwiftyJSON
import CRRefresh

class MoviesViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var movies: [Movie] = []
    var page = 1
    var total_pages = 1
    var filterMovies = FilterMovies.discover
    var state = FilterMovies.discover// para poder volver al estado anterior al realizar búsquedas
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        //Se encarga de refrescar el contenido cuando el usuario desliza el dedo hacia abajo
        collectionView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) {[weak self] in
            
            self?.resetContent()
            self?.getData {() -> () in
                self?.collectionView.reloadData()
                self?.collectionView.cr.endHeaderRefresh()
            }
            
        }

        getData {() -> () in
            self.collectionView.reloadData()
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
        cell.moviePoster.layer.cornerRadius = 10.0
        if let poster = movies[indexPath.row].posterUrl {
            let posterImage = repository.getPosterImage(poster: poster)
            cell.moviePoster.image = posterImage
        }
        else {
            cell.moviePoster.image = UIImage(named: "No Image")
        }
        
        return utils.customCardMoviesAndTVShows(cell: cell)
    }
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        
        let view: UISearchBar?
        
        if (navigationItem.titleView == searchBar) {
            resetContent()
            filterMovies = state
            view = nil
            getData {
                self.collectionView.reloadData()
            }
        }
        else {
            view = searchBar
        }
        navigationItem.titleView = view
        searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        if searchBar.text == "" {
            utils.showToast(message: "The search bar is empty", view: view)
        }
        else {
            resetContent()
            state = filterMovies
            filterMovies = .searchMovie
            getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {

        let options = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        let discover = UIAlertAction(title: "Discover movies", style: .default, handler: { (UIAlertAction) in
            
            self.resetContent()
            self.filterMovies = .discover
            self.state = self.filterMovies
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }
            
        })
        
        let popular = UIAlertAction(title: "Popular movies", style: .default, handler: { (UIAlertAction) in
            
            self.resetContent()
            self.filterMovies = .popular
            self.state = self.filterMovies
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }

        })
        
        let top = UIAlertAction(title: "Top rated", style: .default) { (alert: UIAlertAction) in
            
            self.resetContent()
            self.filterMovies = .top_rated
            self.state = self.filterMovies
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }

        }
        
        let release = UIAlertAction(title: "Release date (asc)", style: .default) { (alert: UIAlertAction) in
            
            self.resetContent()
            self.filterMovies = .release_date
            self.state = self.filterMovies
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
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
    
    @IBAction func addFavoriteMovie(_ sender: UIButton) {
        
    }
    
    //Scroll infinito
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == movies.count - 1 && page < total_pages{
            page += 1
            getData {() -> () in
                self.collectionView.reloadData()
            }
        }
    }
    
    func getData(completionHandler:@escaping (() -> ())) {
        
        //La vista de películas puede mostrar los datos filtrados por diversos criterios (películas populares, mejor valoradas,...) por lo que cuando un usuario
        //realiza scroll en la pantalla debe conocerse qué criterio está fijado para cargar los datos de la página correspondiente
        //de una dirección u otra. Una manera de hacer esto es mediante una variable, en este caso content, que almacena la opción seleccionada y
        //en función de su valor se obtienen los datos correspondientes. Además cuando se cambia de criterio de visualización (de películas populares a mejor valoradas p.e.)
        //debe hacerse scroll a la parte superior automáticamente para que se visualice el primer elemento del array de películas pero teniendo en cuenta la reutilización de
        //celdas. Para ello se ha usado una closure que informa de la disponibilidad de los datos en el modelo.
        
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)
        switch filterMovies {
            case .discover:
                repository.discoverMovies(page: page){ responseObject, error in
                    
                    self.saveDataToModel(data: responseObject, error: error)
                    self.utils.stopLoadingIndicator(indicator: indicator)
                    completionHandler()
            }
            case .popular:
                repository.getPopularMovies(page: page){ responseObject, error in
                    
                    self.saveDataToModel(data: responseObject, error: error)
                    self.utils.stopLoadingIndicator(indicator: indicator)
                    completionHandler()
            }
            case .top_rated:
                repository.getTopRatedMovies(page: page) { responseObject, error in
                    
                    self.saveDataToModel(data: responseObject, error: error)
                    self.utils.stopLoadingIndicator(indicator: indicator)
                    completionHandler()
            }
            case .release_date:
                repository.moviesReleaseDateAsc(page: page) { responseObject, error in
                    
                    self.saveDataToModel(data: responseObject, error: error)
                    self.utils.stopLoadingIndicator(indicator: indicator)
                    completionHandler()
            }
            default:
                repository.searchMovie(page: page, query: searchBar.text!) {responseObject,error in

                    self.saveDataToModel(data: responseObject, error: error)
                    self.utils.stopLoadingIndicator(indicator: indicator)
                    completionHandler()
            }
        }
    }
    
    //Esta función recorre el objeto JSON que tiene la información de las películas y almacena estos datos en el modelo
    func saveDataToModel(data: JSON?, error: NSError?) {

        if let response = data {
            
            total_pages = response["total_pages"].int!
            for item in response["results"] {
                let movie = Movie(id: item.1["id"].int!, title: item.1["title"].string!, posterUrl: item.1["poster_path"].string,
                                  vote: item.1["vote_average"].float!, release: item.1["release_date"].string!, overview: item.1["overview"].string!)
                self.movies.append(movie)
            }
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
        total_pages = 1
        movies.removeAll()
    }
    
    //Abrir detalle película
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MovieViewCell
        let indexPath = collectionView.indexPath(for: cell)
        let detailViewController = segue.destination as! MovieDetailViewController
        detailViewController.id = movies[(indexPath?.row)!].id
    }
    
}
