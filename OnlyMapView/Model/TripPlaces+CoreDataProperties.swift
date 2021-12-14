//
//  TripPlaces+CoreDataProperties.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 08.12.2021.
//
//

import Foundation
import CoreData


extension TripPlaces {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripPlaces> {
        return NSFetchRequest<TripPlaces>(entityName: "TripPlaces")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var image: String?
    @NSManaged public var kinds: String?
    @NSManaged public var name: String?
    @NSManaged public var rate: Int16
    @NSManaged public var url: String?
    @NSManaged public var wikipedia: String?
    @NSManaged public var wikipedia_extracts: String?
    @NSManaged public var xid: String?
    @NSManaged public var belongTo: TripLists?

    public var wrappedName : String {
        name ?? "unknown name"
    }
}

extension TripPlaces : Identifiable {

}
