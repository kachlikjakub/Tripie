//
//  TripPickerViewModel.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 08.12.2021.
//

import Foundation
import SwiftUI

class TripPickerViewModel: ObservableObject {
    @Published var TripListModel : TripPickerModel
    init(list:FetchedResults<TripLists>){
        self.TripListModel = TripPickerModel(ListOfTrips: list)
    }
    
  
}
