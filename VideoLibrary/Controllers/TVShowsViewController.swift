
import UIKit
import SwiftyJSON
import CRRefresh
import FloatingActionSheetController

class TVShowsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    let repository = MovieDatabaseRepository()
    let utils = Utils()
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
        
        return utils.customCardMoviesAndTVShows(cell: cell)
    }
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        
        let view: UISearchBar?
        
        if (navigationItem.titleView == searchBar) {
            resetContent()
            filterShows = state
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
            state = filterShows
            filterShows = .searchTVShow
            getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
                searchBar.endEditing(true)
            }
        }
    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        
        let discover = FloatingAction(title: NSLocalizedString("discoverTVShows", comment: "")) { action in
            
            self.resetContent()
            self.filterShows = .discoverTVShow
            self.state = self.filterShows
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }
        }
        
        let popular = FloatingAction(title: NSLocalizedString("popularTVShows", comment: "")) { action in
            
            self.resetContent()
            self.filterShows = .popularTVShow
            self.state = self.filterShows
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }
        }
        
        let top = FloatingAction(title: NSLocalizedString("topRatedShows", comment: "")) { action in

            self.resetContent()
            self.filterShows = .topRatedTVShow
            self.state = self.filterShows
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }
        }
        
        let on_air = FloatingAction(title: NSLocalizedString("onAir", comment: "")) { action in
            
            self.resetContent()
            self.filterShows = .on_air
            self.state = self.filterShows
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }
        }
        
        let group = FloatingActionGroup(action: discover, popular, top, on_air)
        let actionSheet = FloatingActionSheetController(actionGroup: group).present(in: self)
        actionSheet.animationStyle = .pop
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == tvShows.count - 1 && page < total_pages{
            page += 1
            getData {() -> () in
                self.collectionView.reloadData()
            }
        }
    }
    
    func getData(completionHandler:@escaping (() -> ())) {
        
        //Función análoga a la del controlador de películas pero aplicada a series. En el caso de elegir una opción de visualización de series presente
        //en el action sheet, se necesita hacer scroll a la primera celda de la colección para que se visualice a partir del primer elemento por lo que
        //hay que saber si los datos estan almacenados y listos para presentarse en pantalla para evitar problemas en la reutilización de celdas. Para esto se utiliza una
        //closure que informa de la disponibilidad de los datos en el modelo.
        
        let indicator = utils.showLoadingIndicator(title: NSLocalizedString("loading", comment: "Texto que indica la carga de un recurso"), view: view)
        switch filterShows {
        case .discoverTVShow:
            repository.discoverTVShows(page: page){ responseObject, error in
                
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        case .popularTVShow:
            repository.getPopularTVShows(page: page){ responseObject, error in
                
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        case .topRatedTVShow:
            repository.getTopRatedTVShows(page: page) { responseObject, error in
                
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        case .on_air:
            repository.getOnAirTVShows(page: page) { responseObject, error in
                
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        default:
            repository.searchTVShow(page: page, query: searchBar.text!) { responseObject, error in
                
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        }
    }
    
    //Esta función recorre el objeto JSON que tiene la información de las series y almacena estos datos en el modelo
    func saveDataToModel(data: JSON?, error: NSError?) {

        if let response = data {
            
            total_pages = response["total_pages"].int!
            
            for item in response["results"] {
                
                let show = OMTVShow(id: item.1["id"].intValue, name: item.1["name"].stringValue, posterUrl: item.1["poster_path"].string,
                                    vote: item.1["vote_average"].floatValue, firstAir: item.1["first_air_date"].stringValue)
                
                self.tvShows.append(show)
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
        let favorite = Favorites()
        
        if favorite.addFavoriteShow(id: showId, name: showName, image: showImage) {
            
            utils.showToast(message: NSLocalizedString("showAdded", comment: ""), view: view)
        }
    }
}

extension TVShowsViewController {
    
    //Al hacer scroll se oculta el teclado
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}
