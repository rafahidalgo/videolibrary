
import UIKit

class PeopleDetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var deathdayLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let utils = Utils()
    let repository = MovieDatabaseRepository()
    var id: Int!
    var photo: String?
    var credits: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        getDetails(id: id)
        getMovies(id: id)
        getTVShows(id: id)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
    
    
//Obtención de datos del actor por id
extension PeopleDetailViewController {
    func getDetails(id: Int) {
        
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)
        
        repository.getPersonDetail(id: id) { (responseObject, error) in
            if let response = responseObject {
                let name = response["name"].string ?? nil
                let photo = response["profile_path"].string ?? nil
                var biography = response["biography"].string ?? nil
                if biography == "" {
                    biography = "The biography is not available in the requested language"
                }
                let birthday = response["birthday"].string ?? "-"
                let deathday = response["deathday"].string ?? "-"
                let placeOfBirth = response["place_of_birth"].string ?? "-"
                let person = ActorDetails(id: id, name: name!, photoURL: photo, biography: biography, birthday: birthday, deathday: deathday, placeOfBirth: placeOfBirth)
                
                if let imageURL = person.photoURL {
                    let photoImage = self.repository.getPosterImage(poster: imageURL)
                    self.image.image = photoImage
                } else {
                    self.image.image = UIImage(named: "No Image")
                }
                self.image.layer.cornerRadius = 10
                self.nameLabel.text = person.name
                self.birthdayLabel.text = person.birthday
                self.deathdayLabel.text = person.deathday
                self.biographyLabel.text = person.biography
                self.biographyLabel.sizeToFit()
                self.placeOfBirthLabel.text = person.placeOfBirth
                
                self.utils.stopLoadingIndicator(indicator: indicator)
                return
            }
            
            
            if (error?.code)! < 0 {
                self.utils.showAlertConnectionLost(view: self)
            }
            else {
                self.utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self)
            }
            
        }
    }

}

//Obtención de películas y series del actor indicado
extension PeopleDetailViewController {
    
    func getMovies(id: Int) {
        repository.getMovieCredits(id: id) { (responseObject, error) in
            if let response = responseObject {
                for movie in response["cast"] {
                    let id = movie.1["id"].int!
                    let title = movie.1["title"].string!
                    let posterUrl = movie.1["poster_path"].string ?? nil
                    let movie = Movie(id: id, title: title, posterUrl: posterUrl, vote: 0, release: "")
                    self.credits.append(movie)
                }
                self.collectionView.reloadData()
                return
            }
            
            if (error?.code)! < 0 {
                self.utils.showAlertConnectionLost(view: self)
            }
            else {
                self.utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self)
            }
        }
    }
    
    func getTVShows(id: Int) {
        repository.getTVShowCredits(id: id) { (responseObject, error) in
            if let response = responseObject {
                for show in response["cast"] {
                    let id = show.1["id"].int!
                    let name = show.1["name"].string!
                    let posterUrl = show.1["poster_path"].string ?? nil
                    let show = TVShow(id: id, name: name, posterUrl: posterUrl, vote: 0, first_air: "")
                    self.credits.append(show)
                }
                self.collectionView.reloadData()
                return
            }
            if (error?.code)! < 0 {
                self.utils.showAlertConnectionLost(view: self)
            }
            else {
                self.utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self)
            }
        }
    }
    
    
    
}

//Collection View
extension PeopleDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return credits.count
        //return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let movieIdentifier = "MovieCreditsCell"
        let tvShowIdentifier = "TVShowCreditsCell"
        var customCell: UICollectionViewCell?
        
        if let item = credits[indexPath.row] as? Movie {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieIdentifier, for: indexPath) as! MovieCreditsViewCell
            if let posterUrl = item.posterUrl {
                let posterImage = repository.getPosterImage(poster: posterUrl)
                cell.moviePoster.image = posterImage
            } else {
                cell.moviePoster.image = UIImage(named: "No Image narrow")
            }
            cell.moviePoster.layer.cornerRadius = 10
            customCell = utils.customCardMoviesAndTVShows(cell: cell)
        } else if let item = credits[indexPath.row] as? TVShow {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tvShowIdentifier, for: indexPath) as! TVShowCreditsViewCell
            if let posterUrl = item.posterUrl {
                let posterImage = repository.getPosterImage(poster: posterUrl)
                cell.tvShowPoster.image = posterImage
            } else {
                cell.tvShowPoster.image = UIImage(named: "No Image narrow")
            }
            cell.tvShowPoster.layer.cornerRadius = 10
            customCell = utils.customCardMoviesAndTVShows(cell: cell)
        }
        
        return customCell!
    }
    
}

//Detalles de la película o serie seleccionada
extension PeopleDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let cell = sender as? MovieCreditsViewCell
        {
            let indexPath = collectionView.indexPath(for: cell)
            let detailViewController = segue.destination as! MovieDetailViewController
            let item = credits[(indexPath?.row)!] as! Movie
            detailViewController.id = item.id
        }
        else if let cell = sender as? TVShowCreditsViewCell
        {
            let indexPath = collectionView.indexPath(for: cell)
            let detailViewController = segue.destination as! TVShowDetailViewController
            let item = credits[(indexPath?.row)!] as! TVShow
            detailViewController.id = item.id
        }
    }
}

