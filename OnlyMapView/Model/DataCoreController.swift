//
//  DataCoreController.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 26.11.2021.
//

import Foundation
import CoreData

struct DataController{
    static let shared = DataController()

    let container = NSPersistentContainer(name: "PlacesModel")
    
    init(){
        container.loadPersistentStores{ description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
