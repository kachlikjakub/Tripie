//
//  MapMarkers.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 12.11.2021.
//

import Foundation

struct MarkersClass{
    var mapMarkers : [Features] = []
    
    mutating func addMarker(marker: Features){
        mapMarkers.append(marker)
    }
    mutating func resetMarkers(){
        mapMarkers = []
    }
}
