
import UIKit
import SwiftyJSON
import CRRefresh
import FloatingActionSheetController

class MoviesViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var movies: [OMMovie] = []
    var page = 1
    var total_pages = 1
    var filterMovies = FilterMovies.discoverMovie
    var state = FilterMovies.discoverMovie// para poder volver al estado anterior al realizar búsquedas
    
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
        cell.movieRelease.text = movies[indexPath.row].releaseDate
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
            utils.showToast(message: NSLocalizedString("emptySearchBar",
                                                       comment: "Mensaje que se muestra cuando se le da a buscar una película con la barra vacía"),
                                                       view: view)
        }
        else {
            resetContent()
            state = filterMovies
            filterMovies = .searchMovie
            getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
                searchBar.endEditing(true)
            }
        }
    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        
        let discover = FloatingAction(title: NSLocalizedString("discoverMovies", comment: "")) { action in
            
            self.resetContent()
            self.filterMovies = .discoverMovie
            self.state = self.filterMovies
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }
            
        }
        
        let popular = FloatingAction(title: NSLocalizedString("popularMovies", comment: "")) { action in
            
            self.resetContent()
            self.filterMovies = .popularMovie
            self.state = self.filterMovies
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }

        }
        
        let top = FloatingAction(title: NSLocalizedString("topRatedMovies", comment: "")) { action in
            
            self.resetContent()
            self.filterMovies = .topRatedMovie
            self.state = self.filterMovies
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }

        }
        
        let release = FloatingAction(title: NSLocalizedString("releaseDate", comment: "")) { action in
            
            self.resetContent()
            self.filterMovies = .release_date
            self.state = self.filterMovies
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }
            
        }
        
        let group = FloatingActionGroup(action: discover, popular, top, release)
        let actionSheet = FloatingActionSheetController(actionGroup: group).present(in: self)
        actionSheet.animationStyle = .slideUp
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
        
        let indicator = utils.showLoadingIndicator(title: NSLocalizedString("loading", comment: "Texto que indica la carga de un recurso"), view: view)
        switch filterMovies {
            case .discoverMovie:
                repository.discoverMovies(page: page){ responseObject, error in
                    
                    self.saveDataToModel(data: responseObject, error: error)
                    self.utils.stopLoadingIndicator(indicator: indicator)
                    completionHandler()
            }
            case .popularMovie:
                repository.getPopularMovies(page: page){ responseObject, error in
                    
                    self.saveDataToModel(data: responseObject, error: error)
                    self.utils.stopLoadingIndicator(indicator: indicator)
                    completionHandler()
            }
            case .topRatedMovie:
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

                let movie = OMMovie(id: item.1["id"].intValue, title: item.1["title"].stringValue, posterUrl: item.1["poster_path"].string,
                                    vote: item.1["vote_average"].floatValue, releaseDate: item.1["release_date"].stringValue)

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
    
    //Reset del contenido
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

extension MoviesViewController {
    
    @IBAction func addFavoriteMovie(_ sender: UIButton) {
       
        guard let cell = sender.superview?.superview as? MovieViewCell else {
            utils.showAlertWithCustomMessage(title: "Error", message: NSLocalizedString("favoriteError", comment: ""), view: self)
            return
        }
        
        let indexPath = collectionView.indexPath(for: cell)
        let movieId = movies[(indexPath?.row)!].id
        let movieTitle = movies[(indexPath?.row)!].title
        let movieImage = movies[(indexPath?.row)!].posterUrl
        let favorite = Favorites()
        
        if favorite.addFavoriteMovie(id: movieId, title: movieTitle, image: movieImage) {
            
            utils.showToast(message: NSLocalizedString("movieAdded", comment: ""), view: view)
        }
    }
}

extension MoviesViewController {
    
    //Al hacer scroll se oculta el teclado
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}
