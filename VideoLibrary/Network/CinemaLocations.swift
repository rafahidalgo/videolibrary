

import Foundation
import MapKit

protocol CinemaLocations {
    
    func getCinemaLocations(coordinates: MKCoordinateRegion, completionHandler: @escaping ([MKMapItem]?, NSError?) -> ())    
    
}
