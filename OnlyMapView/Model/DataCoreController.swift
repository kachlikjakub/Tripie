//
//  DataCoreController.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 26.11.2021.
//

import Foundation
import CoreData

class DataController{
    static let shared = DataController()

    let container = NSPersistentContainer(name: "PlacesModel")
    
    init(){
        container.loadPersistentStores{ description, error in
            if let error = error {
                //print(error)
                fatalError("Error: \(error.localizedDescription)")
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
