

import Foundation
import MapKit

struct NearbyCinemas: CinemaLocations {
    
    let request: MKLocalSearchRequest
    
    init() {
        self.request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "cinema"
    }
    
    func getCinemaLocations(coordinates: MKCoordinateRegion, completionHandler: @escaping ([MKMapItem]?, NSError?) -> ()) {
        self.request.region = coordinates
        let search = MKLocalSearch(request: self.request)
        search.start { response, error in
            guard let response = response else {
                completionHandler(nil, error as NSError?)
                return
            }
            var cinemaPlaces = [MKMapItem]()
            for place in response.mapItems {
                cinemaPlaces.append(place)
            }            
            completionHandler(cinemaPlaces, nil)
            return            
        }
    }
    
    
    
    
}
