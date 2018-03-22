
import UIKit
import SwiftyJSON
import CRRefresh
import FloatingActionSheetController

class TVShowsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    let favorite = Favorites()
    var tvShows: [OMTVShow] = []
    var page = 1
    var total_pages = 1
    var filterShows = FilterShows.discoverTVShow
    var state = FilterShows.discoverTVShow// para poder volver al estado anterior al realizar búsquedas

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
        guard tabBarController?.selectedIndex == 1 else {return}
        self.utils.sizeCell(widthScreen: size.width, collectionView: self.collectionView)
    }
    
    //Si se cambia la orientación en otra pestaña, al volver a ésta se redimensiona
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.utils.sizeCell(widthScreen: self.view.bounds.width, collectionView: self.collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //Reset del contenido
    func resetContent() {
        page = 1
        total_pages = 1
        tvShows.removeAll()
    }
    
    //Abrir detalle serie
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! TVShowViewCell
        let indexPath = collectionView.indexPath(for: cell)
        let detailViewController = segue.destination as! TVShowDetailViewController
        detailViewController.id = tvShows[(indexPath?.row)!].id
    }
    
}



//Notificaciones locales
extension TVShowsViewController {
    
    func addNotificationObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNotification(notification:)), name: Notification.Name(notificationKeyShows), object: nil)
    }
    
    @objc func setNotification(notification: NSNotification) {
        collectionView.reloadData()
    }
}



//CollectionView
extension TVShowsViewController {
    
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
            let posterImage = repository.getPosterImage(poster: poster)
            cell.tvPoster.image = posterImage
        }
        else {
            cell.tvPoster.image = UIImage(named: "No Image")
        }
        
        //Comprobamos si la serie está en favoritos
        if favorite.searchTVShow(id: tvShows[indexPath.row].id) != nil {
            
            cell.favoriteButton.setImage(UIImage(named: "Favorite small"), for: .normal)
        }
        else {
            
            cell.favoriteButton.setImage(UIImage(named: "No favorite"), for: .normal)
        }
        return utils.customCardMoviesAndTVShows(cell: cell)
    }
}



//Obtención de datos
extension TVShowsViewController {
    
    func getData(completionHandler:@escaping (() -> ())) {
        
        //Función análoga a la del controlador de películas pero aplicada a series. En el caso de elegir una opción de visualización de series presente
        //en el action sheet, se necesita hacer scroll a la primera celda de la colección para que se visualice a partir del primer elemento por lo que
        //hay que saber si los datos estan almacenados y listos para presentarse en pantalla para evitar problemas en la reutilización de celdas. Para esto se utiliza una
        //closure que informa de la disponibilidad de los datos en el modelo.
        
        let indicator = utils.showLoadingIndicator(title: NSLocalizedString("loading", comment: "Texto que indica la carga de un recurso"), view: view)
        switch filterShows {
        case .discoverTVShow:
            repository.discoverTVShows(page: page){[weak self] responseObject, error, pages in
                
                self?.saveDataToModel(data: responseObject, error: error, pages: pages!)
                self?.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        case .popularTVShow:
            repository.getPopularTVShows(page: page){[weak self] responseObject, error, pages in
                
                self?.saveDataToModel(data: responseObject, error: error, pages: pages!)
                self?.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        case .topRatedTVShow:
            repository.getTopRatedTVShows(page: page) {[weak self] responseObject, error, pages in
                
                self?.saveDataToModel(data: responseObject, error: error, pages: pages!)
                self?.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        case .on_air:
            repository.getOnAirTVShows(page: page) {[weak self] responseObject, error, pages in
                
                self?.saveDataToModel(data: responseObject, error: error, pages: pages!)
                self?.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        default:
            repository.searchTVShow(page: page, query: searchBar.text!) {[weak self] responseObject, error, pages in
                
                self?.saveDataToModel(data: responseObject, error: error, pages: pages!)
                self?.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        }
    }
    
    //Esta función coge la información de las series y almacena estos datos en el modelo
    func saveDataToModel(data: [OMTVShow]?, error: NSError?, pages: Int) {
        
        if let response = data {
            
            total_pages = pages
            
            self.tvShows.append(contentsOf: response)
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



//Añadir serie a favoritos
extension TVShowsViewController {
    
    @IBAction func addFavoriteShow(_ sender: UIButton) {
        
        guard let cell = sender.superview?.superview as? TVShowViewCell else {
            utils.showAlertWithCustomMessage(title: "Error", message: NSLocalizedString("favoriteError", comment: ""), view: self)
            return
        }
        
        let indexPath = collectionView.indexPath(for: cell)
        let showId = tvShows[(indexPath?.row)!].id
        let showName = tvShows[(indexPath?.row)!].name
        let showImage = tvShows[(indexPath?.row)!].posterUrl
        let showVotes = tvShows[(indexPath?.row)!].vote
        
        //Hay que mirar si debemos borrar o agregar una serie a favoritos.
        if favorite.searchTVShow(id: tvShows[(indexPath?.row)!].id) != nil && favorite.deleteFavoriteShow(id: showId) {
            
            cell.favoriteButton.setImage(UIImage(named: "No favorite"), for: .normal)
            utils.showToast(message: NSLocalizedString("showDeleted", comment: ""), view: view)
            
        }
        else {
            
            if favorite.addFavoriteShow(id: showId, name: showName, image: showImage, vote: showVotes) {
                
                cell.favoriteButton.setImage(UIImage(named: "Favorite small"), for: .normal)
                utils.showToast(message: NSLocalizedString("showAdded", comment: ""), view: view)
            }
        }
    }
}



//Barra de búsqueda
extension TVShowsViewController {

    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        
        let view: UISearchBar?
        
        if (navigationItem.titleView == searchBar) {
            resetContent()
            filterShows = state
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
            state = filterShows
            filterShows = .searchTVShow
            getData {[weak self] () -> () in
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self?.collectionView.reloadData()
                searchBar.endEditing(true)
            }
        }
    }
}



//Action sheet
extension TVShowsViewController {
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        
        let discover = FloatingAction(title: NSLocalizedString("discoverTVShows", comment: "")) {[weak self] action in
            
            self?.resetContent()
            self?.filterShows = .discoverTVShow
            self?.state = (self?.filterShows)!
            self?.getData {[weak self] () -> () in
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self?.collectionView.reloadData()
            }
        }
        
        let popular = FloatingAction(title: NSLocalizedString("popularTVShows", comment: "")) {[weak self] action in
            
            self?.resetContent()
            self?.filterShows = .popularTVShow
            self?.state = (self?.filterShows)!
            self?.getData {[weak self] () -> () in
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self?.collectionView.reloadData()
            }
        }
        
        let top = FloatingAction(title: NSLocalizedString("topRatedShows", comment: "")) {[weak self] action in
            
            self?.resetContent()
            self?.filterShows = .topRatedTVShow
            self?.state = (self?.filterShows)!
            self?.getData {[weak self] () -> () in
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self?.collectionView.reloadData()
            }
        }
        
        let on_air = FloatingAction(title: NSLocalizedString("onAir", comment: "")) {[weak self] action in
            
            self?.resetContent()
            self?.filterShows = .on_air
            self?.state = (self?.filterShows)!
            self?.getData {[weak self] () -> () in
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self?.collectionView.reloadData()
            }
        }
        
        let group = FloatingActionGroup(action: discover, popular, top, on_air)
        let actionSheet = FloatingActionSheetController(actionGroup: group).present(in: self)
        actionSheet.animationStyle = .pop
    }
}



//Scroll
extension TVShowsViewController {
    
    //Scroll infinito
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == tvShows.count - 1 && page < total_pages{
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


