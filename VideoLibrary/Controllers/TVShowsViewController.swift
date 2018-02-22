
import UIKit
import SwiftyJSON

class TVShowsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var tvShows: [TVShow] = []
    var page = 1
    var total_pages = 1
    var filter = FilterShows.discover

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
            repository.getPosterImage(poster: poster, imageView: cell.tvPoster)
        }
        else {
            cell.tvPoster.image = UIImage(named: "No Image")
        }
        
        return utils.customCardMoviesAndTVShows(cell: cell)
    }
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        
        
    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        
        let options = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        let discover = UIAlertAction(title: "Discover TV Shows", style: .default, handler: { (UIAlertAction) in
            
            self.resetContent()
            self.filter = .discover
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }
        })
        
        let popular = UIAlertAction(title: "Popular TV Shows", style: .default, handler: { (UIAlertAction) in
            
            self.resetContent()
            self.filter = .popular
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }
        })
        
        let top = UIAlertAction(title: "Top rated", style: .default) { (alert: UIAlertAction) in

            self.resetContent()
            self.filter = .top_rated
            self.getData {() -> () in
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                self.collectionView.reloadData()
            }
        }
        
        let on_air = UIAlertAction(title: "On air", style: .default) { (alert: UIAlertAction) in
            
            self.resetContent()
            self.filter = .on_air
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
        options.addAction(on_air)
        options.addAction(cancel)
        
        //Crash del action sheet en tablets https://stackoverflow.com/questions/31577140/uialertcontroller-is-crashed-ipad/31577494
        if let popover = options.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 1.0, height: 1.0)
        }
        
        self.present(options, animated: true, completion: nil)
    }
    
    @IBAction func addFavoriteShow(_ sender: UIButton) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == tvShows.count - 1 {
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
        
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)
        switch filter {
        case .discover:
            repository.discoverTVShows(page: page){ responseObject, error in
                
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        case .popular:
            repository.getPopularTVShows(page: page){ responseObject, error in
                
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        case .top_rated:
            repository.getTopRatedTVShows(page: page) { responseObject, error in
                
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        default:
            repository.getOnAirTVShows(page: page) { responseObject, error in
                
                self.saveDataToModel(data: responseObject, error: error)
                self.utils.stopLoadingIndicator(indicator: indicator)
                completionHandler()
            }
        }
    }
    
    //Esta función recorre el objeto JSON que tiene la información de las series y almacena estos datos en el modelo
    func saveDataToModel(data: JSON?, error: NSError?) {

        if let response = data {
            
            for item in response["results"] {
                let show = TVShow(id: item.1["id"].int!, name: item.1["name"].string!, posterUrl: item.1["poster_path"].string,
                                  vote: item.1["vote_average"].float!, first_air: item.1["first_air_date"].string!, overview: item.1["overview"].string!)
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
    
    func resetContent() {
        page = 1
        tvShows.removeAll()
    }
    
}
