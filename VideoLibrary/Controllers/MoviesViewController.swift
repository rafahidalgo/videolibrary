
import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let repository = MovieDatabaseRepository()
    let utils = Utils()
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)
        indicator.0.startAnimating()
        view.addSubview(indicator.1)
        
        repository.discoverMovies(){ responseObject, error in
            if let response = responseObject {
                for item in response["results"] {
                    let movie = Movie(id: item.1["id"].int!, title: item.1["title"].string!, posterUrl: item.1["poster_path"].string,
                                      vote: item.1["vote_average"].float!, release: item.1["release_date"].string!, overview: item.1["overview"].string!)
                    self.movies.append(movie)
                }
                self.tableView.reloadData()
                indicator.0.stopAnimating()
                indicator.1.removeFromSuperview()
                return
            }
            print("\(String(describing: error))")
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieViewCell
        
        cell.movieTitle.text = movies[indexPath.row].title
        if let poster = movies[indexPath.row].posterUrl {
            let url = repository.getPosterImage(poster: poster)
            cell.moviePoster.af_setImage(withURL: url!)
        }
        else {
            //TODO no image da null
            
        }
        
        return cell
    }
    
    @IBAction func showActionSheet(_ sender: UIBarButtonItem) {
        
        let options = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        let discover = UIAlertAction(title: "Discover movies", style: .default, handler: { (UIAlertAction) in
            
        })
        
        let popular = UIAlertAction(title: "Popular movies", style: .default, handler: { (UIAlertAction) in
            self.repository.getPopularMovies()
        })
        
        let top = UIAlertAction(title: "Top rated", style: .default) { (alert: UIAlertAction) in
            print("Has pulsado popular")
        }
        
        let release = UIAlertAction(title: "Release date (asc)", style: .default) { (alert: UIAlertAction) in
            print("Has pulsado popular")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction) in
            
        }
        
        options.addAction(discover)
        options.addAction(popular)
        options.addAction(top)
        options.addAction(release)
        options.addAction(cancel)
        
        self.present(options, animated: true, completion: nil)
    }
    
    func resetContent() {
        
        
    }
    
}
