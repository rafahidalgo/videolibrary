
import UIKit

class PeopleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var people: [Actor] = []
    let utils = Utils()
    var page = 1
    let repository = MovieDatabaseRepository()
    var searching = false
    var nameSearched = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        searchPopularPeople(page: page)

    }

    
    //CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PeopleViewCell
        cell.actorName.text = self.people[indexPath.row].name
        if let imageURL = self.people[indexPath.row].photoURL {
            repository.getPosterImage(poster: imageURL, view: cell.actorImage)
        } else {
            //TODO si no hay foto
        }
        
        cell.contentView.layer.cornerRadius = 10.0
        cell.actorImage.layer.cornerRadius = 10.0 //TODO Quitar radio de la parte inferior
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
        
    }
    
    //Funcionalidad botón search
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        
        let view = (navigationItem.titleView == searchBar) ? nil : searchBar
        navigationItem.titleView = view
        searchBar.text = nil
        
    }
    
    //Funcionalidad barra search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
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
    
    //Búsqueda de actores populares
    
    func searchPopularPeople(page: Int) {
        
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)
        indicator.0.startAnimating()
        view.addSubview(indicator.1)
        
        repository.discoverPeople(page: page) { (responseObject, error) in
            if let response = responseObject {
                for item in response["results"] {
                    if let name = item.1["name"].string {
                        if let photo = item.1["profile_path"].string {
                            let actor = Actor(name: name, photoURL: photo)
                            self.people.append(actor)
                        }
//                        else {
//                            let actor = Actor(name: name, photoURL: nil) //TODO poner imagen de no hay foto
//                            self.people.append(actor)
//                        }
                    }
                    
                }
                self.collectionView.reloadData()
                indicator.0.stopAnimating()
                indicator.1.removeFromSuperview()
                return
            }
            print("\(String(describing: error))")
            //TODO metemos alerta?
        }
    }
    
    
    //Búsqueda de actores por nombre completo
    
    func searchPerson(name: String, page: Int) {
        
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)
        indicator.0.startAnimating()
        view.addSubview(indicator.1)
        
        repository.getPerson(name: name, page: page) { (responseObject, error) in
            if let response = responseObject {
                for item in response["results"] {
                    if let name = item.1["name"].string {
                        if let photo = item.1["profile_path"].string {
                            let actor = Actor(name: name, photoURL: photo)
                            self.people.append(actor)
                        }
//                        else {
//                            let actor = Actor(name: name, photoURL: nil) //TODO poner imagen de no hay foto
//                            self.people.append(actor)
//                        }
                    }
                }
                self.collectionView.reloadData()
                indicator.0.stopAnimating()
                indicator.1.removeFromSuperview()
                return
            }
            print("\(String(describing: error))")
            //TODO metemos alerta?
        }
    }
    
    //Scroll infinito
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == people.count - 1 {
            page += 1
            if self.searching {
                self.searchPerson(name: self.nameSearched, page: page)
            } else {
                self.searchPopularPeople(page: page)
            }
            
        }
    }
    
    //Resetear el contenido
    func resetContent() {
        self.page = 1
        self.people.removeAll()
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    
}
