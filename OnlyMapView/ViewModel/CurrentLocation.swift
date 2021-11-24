import Foundation
import CoreLocation
import Combine
import MapKit

final class CurrentLocation: NSObject, ObservableObject, CLLocationManagerDelegate{
    var locationManager : CLLocationManager?

    @Published var region2 = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 50.075539,
                                       longitude: 14.437800),
        latitudinalMeters: 10000,
        longitudinalMeters: 10000
    )
    
    func checkIfLocationIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            checkLocationPermissions()
        }
        else{
            print ("location disabled in system")
        }
    }
    
    private func checkLocationPermissions(){
        guard let locationManager = self.locationManager else {
            return
        }
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("parents disabled you this function.")
        case .denied:
            print("other problem.")
        case .authorizedAlways, .authorizedWhenInUse:
            region2 = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 50.075539,
                                                                                                                longitude: 14.437800), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermissions()
    }
}
