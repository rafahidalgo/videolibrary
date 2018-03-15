
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!    
    let locationManager = CLLocationManager()
    let nearbyCinemas = NearbyCinemas()
    let utils = Utils()
    var cinemaPins = [CinemaPin]()
    
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!    
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        //Annotations
        mapView.delegate = self
        
        //button
        resizeButton()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizeButton()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

//User location
extension MapViewController: CLLocationManagerDelegate  {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            //Detener hilo
            fallthrough
        case .authorizedWhenInUse:
            if let lat = locationManager.location?.coordinate.latitude,
                let long = locationManager.location?.coordinate.longitude {
                let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                mapView.setRegion(region, animated: true)
                getCinemas(region: region)
                manager.startUpdatingLocation()
            } else {
                utils.showAlertWithCustomMessage(title: "Location error", message: "It was not possible to obtain the location", view: self)
            }
        case .denied:
            utils.showAlertWithCustomMessage(title: "Authorization error", message: "The device can not get the location without authorization", view: self)            
        default:
            print("Status: \(status)")
        }
    }
    
}


//Annotations
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CinemaPin else {return nil}
        let identifier = "cinema"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let mapButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30,
                                                                 height: 30)))
            mapButton.setBackgroundImage(UIImage(named: "map"), for: UIControlState())
            view.rightCalloutAccessoryView = mapButton
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! CinemaPin
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
    
}

//Nearby Cinemas
extension MapViewController {
    
    func getCinemas(region: MKCoordinateRegion) {
        nearbyCinemas.getCinemaLocations(coordinates: region) { (response, error) in
            if let cinemas = response {
                for cinema in cinemas {
                    let name = cinema.name ?? ""
                    let phone = cinema.phoneNumber ?? ""
                    let coordinate = cinema.placemark.coordinate
                    let cinemaPin = CinemaPin(title: name, subtitle: phone, coordinate: coordinate)
                    self.cinemaPins.append(cinemaPin)
                    print(name)
                }
                self.mapView.addAnnotations(self.cinemaPins)
                return
            }
            self.utils.showAlertWithCustomMessage(title: "Connection error", message: "The device could not connect to the server", view: self)
        }
    }
    
}

//Button resize
extension MapViewController {
    
    func resizeButton() {
        let widthConstraint = UIDevice.current.orientation.isPortrait ? 0.1 : 0.075
        let heightConstraint = UIDevice.current.orientation.isPortrait ? 0.05 : 0.1
        buttonWidth.constant = self.view.frame.width * CGFloat(widthConstraint)
        buttonHeight.constant = self.view.frame.height * CGFloat(heightConstraint)
    }
    
}


    

