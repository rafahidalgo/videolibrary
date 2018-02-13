
import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = APICalls()
        api.discoverMovies(){ responseObject, error in
            if let response = responseObject {
                for item in response["results"] {
                    let movie = Movie(title: item.1["title"].string!, posterUrl: item.1["poster_path"].string)
                    self.movies.append(movie)
                }
                self.tableView.reloadData()
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
        //cell.moviePoster.setI
        return cell
    }
    

}
