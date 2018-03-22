
import UIKit
import CRRefresh

class PeopleViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var people: [RHActor] = []
    let utils = Utils()
    var page = 1
    let repository = MovieDatabaseRepository()
    var searching = false
    var nameSearched = ""
    var totalPages = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        //Se encarga de refrescar el contenido cuando el usuario desliza el dedo hacia abajo
        collectionView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) {[weak self] in
            self?.resetContent()
            self?.searchPopularPeople(page: (self?.page)!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.collectionView.cr.endHeaderRefresh()
            })
        }
        
        searchPopularPeople(page: page)
        sizePeopleCell(widthScreen: view.bounds.width)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard tabBarController?.selectedIndex == 2 else {return}
        sizePeopleCell(widthScreen: size.width)
    }
    
    //Si se cambia la orientación en otra pestaña, al volver a ésta se redimensiona
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sizePeopleCell(widthScreen: view.bounds.width)
    }
    
    
    //Pasar id al controlador de detalle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PeopleViewCell
        let indexPath = collectionView.indexPath(for: cell)
        let detailViewController = segue.destination as! PeopleDetailViewController
        detailViewController.id = people[(indexPath?.row)!].id
    }
    
}



//CollectionView
extension PeopleViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PeopleViewCell
        cell.actorName.text = self.people[indexPath.row].name
        if let imageURL = self.people[indexPath.row].photoURL {
            let posterImage = repository.getPosterImage(poster: imageURL)
            cell.actorImage.image = posterImage
        } else {
            cell.actorImage.image = UIImage(named: "No Image")
        }
        cell.actorImage.layer.cornerRadius = 10.0
        let customCell = utils.customCardPersons(cell: cell)
        
        return customCell
        
    }
}



//Formato de las celdas
extension PeopleViewController {
    
    func sizePeopleCell(widthScreen: CGFloat) {
        //Horizontal -> 4 columnas   Vertical -> 3 columnas
        let itemsPerRow: CGFloat = UIDevice.current.orientation.isLandscape ? 4 : 2
        let padding: CGFloat = 10
        let utilWidth = widthScreen - padding * (itemsPerRow * 2)
        let itemWidth = utilWidth / itemsPerRow
        let itemHeight = itemWidth * (4/3)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.collectionViewLayout = layout
    }
    
}



//Obtención de datos
extension PeopleViewController {
    
    //Búsqueda de actores populares
    func searchPopularPeople(page: Int) {
        
        let indicator = utils.showLoadingIndicator(title: NSLocalizedString("loading", comment: "Texto que indica la carga de un recurso"), view: view)
        
        repository.discoverPeople(page: page) {[weak self] (responseObject, error, pages) in
            if let response = responseObject {
                
                self?.totalPages = (pages == nil) ? 0: pages!
                
                self?.people.append(contentsOf: response)
                
                self?.collectionView.reloadData()
                self?.utils.stopLoadingIndicator(indicator: indicator)
                return
            }
            
            if (error?.code)! < 0 {
                self?.utils.showAlertConnectionLost(view: self!)
            }
            else {
                self?.utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self!)
            }
        }
    }
    
    
    //Búsqueda de actores por nombre completo
    func searchPerson(name: String, page: Int) {
        
        let indicator = utils.showLoadingIndicator(title: NSLocalizedString("loading", comment: "Texto que indica la carga de un recurso"), view: view)
        
        repository.getPerson(name: name, page: page) {[weak self] (responseObject, error, pages) in
            if let response = responseObject {
                
                self?.totalPages = (pages == nil) ? 0: pages!
                
                self?.people.append(contentsOf: response)
                
                self?.collectionView.reloadData()
                self?.utils.stopLoadingIndicator(indicator: indicator)
                return
            }
            
            if (error?.code)! < 0 {
                self?.utils.showAlertConnectionLost(view: self!)
            }
            else {
                self?.utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self!)
            }
        }
    }
}



//Barra search
extension PeopleViewController: UISearchBarDelegate {
    
    //Funcionalidad botón search
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        let view = (navigationItem.titleView == searchBar) ? nil : searchBar
        navigationItem.titleView = view
        searchBar.text = nil
    }
    
    //Funcionalidad barra search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if searchBar.text == "" {
            self.searching = false
            resetContent()
            searchPopularPeople(page: page)
        } else {
            self.searching = true
            resetContent()
            self.nameSearched = searchBar.text!
            searchPerson(name: self.nameSearched, page: page)
        }
    }
    
    //Al hacer scroll se oculta el teclado
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    //Resetear el contenido
    func resetContent() {
        self.page = 1
        self.people.removeAll()
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
}



//Scroll infinito
extension PeopleViewController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if self.totalPages == 1 || self.page == self.totalPages {
            return
        }
        if indexPath.row == people.count - 1 {
            page += 1
            if self.searching {
                self.searchPerson(name: self.nameSearched, page: page)
            } else {
                self.searchPopularPeople(page: page)
            }
        }
    }
}





