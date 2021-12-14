//
//  TripLists+CoreDataProperties.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 08.12.2021.
//
//

import Foundation
import CoreData


extension TripLists {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripLists> {
        return NSFetchRequest<TripLists>(entityName: "TripLists")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var isListOf: NSSet?
    
    public var wrappedName : String {
        name ?? "unknown name"
    }
    public var arrayOfPlaces : [TripPlaces] {
        let set = isListOf as? Set<TripPlaces> ?? []
        return set.sorted{
            $0.wrappedName < $1.wrappedName
        }
    }
}



// MARK: Generated accessors for isListOf
extension TripLists {

    @objc(addIsListOfObject:)
    @NSManaged public func addToIsListOf(_ value: TripPlaces)

    @objc(removeIsListOfObject:)
    @NSManaged public func removeFromIsListOf(_ value: TripPlaces)

    @objc(addIsListOf:)
    @NSManaged public func addToIsListOf(_ values: NSSet)

    @objc(removeIsListOf:)
    @NSManaged public func removeFromIsListOf(_ values: NSSet)

}

extension TripLists : Identifiable {

}
