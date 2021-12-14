//
//  TripPickerModel.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 08.12.2021.
//

import Foundation
import SwiftUI

struct TripPickerModel{
    //@FetchRequest(sortDescriptors: [SortDescriptor(\.dateAdded)]) var ListOfTrips: FetchedResults<TripLists>

    var TripsInList : [UUID:Bool] = [:]
    var OnlyList : FetchedResults<TripLists>
    
    init(ListOfTrips: FetchedResults<TripLists>){
        self.OnlyList = ListOfTrips
        for trip in ListOfTrips{
            TripsInList[trip.id!] = false
        }
    }
    
    mutating func toggle(trip:UUID){
        TripsInList[trip]?.toggle()
    }
}
