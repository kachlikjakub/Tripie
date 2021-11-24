//
//  MapModel.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 12.11.2021.
//

import Foundation
import MapKit

struct MapCoordinates{
    
    var defaultLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.075539, longitude: 14.437800), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
}
