
import UIKit
import SwiftyJSON
import CRRefresh
import FloatingActionSheetController

class MoviesViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    let favorite = Favorites()
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
            self?.getData {[weak self] () -> () in
                self?.collectionView.reloadData()
                self?.collectionView.cr.endHeaderRefresh()
            }
            
        }
        
        addNotificationObserver()

        getData {[weak self] () -> () in
            self?.collectionView.reloadData()
        }
        
        //Formateamos la celda
        self.utils.sizeCell(widthScreen: self.view.bounds.width, collectionView: self.collectionView)
    }
    
    //Se formatea la celda en cada cambio de orientación
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard tabBarController?.selectedIndex == 0 else {return}
        self.utils.sizeCell(widthScreen: size.width, collectionView: self.collectionView)
    }
    
    //Si se cambia la orientación en otra pestaña, al volver a ésta se redimensiona
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.utils.sizeCell(widthScreen: self.view.bounds.width, collectionView: self.collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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



//Notificaciones locales
extension MoviesViewController {
    
    func addNotificationObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNotification(notification:)), name: Notification.Name(notificationKeyMovies), object: nil)
    }
    
    @objc func setNotification(notification: NSNotification) {
        collectionView.reloadData()
    }
}



//CollectionView
extension MoviesViewController {
    
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
        
        //Comprobamos si la película está en favoritos
        if favorite.searchMovie(id: movies[indexPath.row].id) != nil {
            
            cell.favoriteButton.setImage(UIImage(named: "Favorite small"), for: .normal)
        }
        else {
            
            cell.favoriteButton.setImage(UIImage(named: "No favorite"), for: .normal)
        }
        
        return utils.customCardMoviesAndTVShows(cell: cell)
    }
}



//Obtención de datos
extension MoviesViewController {
    
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
            repository.discoverMovies(page: page){[weak self] responseObject, error, pages in
                
                self?.saveDataToModel(data: responseObject, error: error, pages: pages!)
                self?.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        case .popularMovie:
            repository.getPopularMovies(page: page){[weak self] responseObject, error, pages  in
                
                self?.saveDataToModel(data: responseObject, error: error, pages: pages!)
                self?.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        case .topRatedMovie:
            repository.getTopRatedMovies(page: page) {[weak self] responseObject, error, pages in
                
                self?.saveDataToModel(data: responseObject, error: error, pages: pages!)
                self?.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        case .release_date:
            repository.moviesReleaseDateAsc(page: page) {[weak self] responseObject, error, pages  in
                
                self?.saveDataToModel(data: responseObject, error: error, pages: pages!)
                self?.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        default:
            repository.searchMovie(page: page, query: searchBar.text!) {[weak self] responseObject, error, pages in
                
                self?.saveDataToModel(data: responseObject, error: error, pages: pages!)
                self?.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        }
    }
    
    //Esta función coge la información de las películas y almacena estos datos en el modelo
    func saveDataToModel(data: [OMMovie]?, error: NSError?, pages: Int) {
        
        if let response = data {
            
            total_pages = pages
            
            self.movies.append(contentsOf: response)
            return
        }
        
        if (error?.code)! < 0 {
            utils.showAlertConnectionLost(view: self)
        }
        else {
            utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self)
        }
    }
}



//Añadir película a favoritos
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
        let movieVote = movies[(indexPath?.row)!].vote
        
        //Hay que mirar si debemos borrar o agregar una película a favoritos.
        if favorite.searchMovie(id: movies[(indexPath?.row)!].id) != nil && favorite.deleteFavoriteMovie(id: movieId) {
                
            cell.favoriteButton.setImage(UIImage(named: "No favorite"), for: .normal)
            utils.showToast(message: NSLocalizedString("movieDeleted", comment: ""), view: view)
            
        }
        else {
            
            if favorite.addFavoriteMovie(id: movieId, title: movieTitle, image: movieImage, vote: movieVote) {
                
                cell.favoriteButton.setImage(UIImage(named: "Favorite small"), for: .normal)
                utils.showToast(message: NSLocalizedString("movieAdded", comment: ""), view: view)
            }
        }
    }
}



//Barra de búsqueda
extension MoviesViewController {
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        
        let view: UISearchBar?
        
        if (navigationItem.titleView == searchBar) {
            resetContent()
            filterMovies = state
            view = nil
            getData {[weak self] in
                self?.collectionView.reloadData()
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
            getData {[weak self] () -> () in
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self?.collectionView.reloadData()
                searchBar.endEditing(true)
            }
        }
    }
}



//Action sheet para filtrar el contenido
extension MoviesViewController {
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        
        let discover = FloatingAction(title: NSLocalizedString("discoverMovies", comment: "")) {[weak self] action in
            
            self?.resetContent()
            self?.filterMovies = .discoverMovie
            self?.state = (self?.filterMovies)!
            self?.getData {[weak self] () -> () in
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self?.collectionView.reloadData()
            }
            
        }
        
        let popular = FloatingAction(title: NSLocalizedString("popularMovies", comment: "")) {[weak self] action in
            
            self?.resetContent()
            self?.filterMovies = .popularMovie
            self?.state = (self?.filterMovies)!
            self?.getData {[weak self] () -> () in
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self?.collectionView.reloadData()
            }
            
        }
        
        let top = FloatingAction(title: NSLocalizedString("topRatedMovies", comment: "")) {[weak self] action in
            
            self?.resetContent()
            self?.filterMovies = .topRatedMovie
            self?.state = (self?.filterMovies)!
            self?.getData {[weak self] () -> () in
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self?.collectionView.reloadData()
            }
            
        }
        
        let release = FloatingAction(title: NSLocalizedString("releaseDate", comment: "")) {[weak self] action in
            
            self?.resetContent()
            self?.filterMovies = .release_date
            self?.state = (self?.filterMovies)!
            self?.getData {[weak self] () -> () in
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self?.collectionView.reloadData()
            }
            
        }
        
        let group = FloatingActionGroup(action: discover, popular, top, release)
        let actionSheet = FloatingActionSheetController(actionGroup: group).present(in: self)
        actionSheet.animationStyle = .slideUp
    }
}



//Scroll
extension MoviesViewController {
    
    //Scroll infinito
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == movies.count - 1 && page < total_pages{
            page += 1
            getData {[weak self] () -> () in
                self?.collectionView.reloadData()
            }
        }
    }
    
    //Al hacer scroll se oculta el teclado
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}





