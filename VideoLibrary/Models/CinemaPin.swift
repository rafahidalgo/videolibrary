import UIKit
import MapKit
import CoreLocation
import Contacts

class CinemaPin: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }
    
    
    //https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started
    //El boton de la anotación abre el mapItem en la aplicación de mapas
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    
}



