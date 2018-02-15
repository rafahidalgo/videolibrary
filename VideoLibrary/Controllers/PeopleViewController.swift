
import UIKit

class PeopleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var people: [Actor] = []
    let utils = Utils()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)
        indicator.0.startAnimating()
        view.addSubview(indicator.1)
        
        let repository = MovieDatabaseRepository()
        repository.discoverPeople { (responseObject, error) in
            if let response = responseObject {
                for item in response["results"] {                    
                    let actor = Actor(name: item.1["name"].string!, photoURL: item.1["profile_path"].string!)
                    self.people.append(actor)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PeopleViewCell
        cell.actorName.text = self.people[indexPath.row].name
        if let imageURL = self.people[indexPath.row].photoURL {
            cell.actorImage.af_setImage(withURL: URL(string: "https://image.tmdb.org/t/p/w500\(imageURL)")!)
            cell.actorImage.clipsToBounds = true
            cell.actorImage.layer.cornerRadius = cell.actorImage.layer.frame.height / 2
        } else {
            //TODO si no hay foto
        }
        
        return cell
        
        
    }
    

  

}
