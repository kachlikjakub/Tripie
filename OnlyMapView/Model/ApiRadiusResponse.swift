//
//  ApiStruct.swift
//  Tripie
//
//  Created by Jakub Kachlík on 24.10.2021.
//

import Foundation

struct ApiRadiusAnswer:Codable{
    let type : String
    let features : [Features]
}
struct Features : Codable, Identifiable{
    let type : String
    let id : String
    let geometry : Geometry
    let properties : Properties
}

struct Geometry:Codable{
    let type : String
    let coordinates : [Float]
}

struct Properties:Codable{
    let xid : String
    let name : String
    let dist : Float
    let rate : Int
    let osm : String?
    let wikidata : String?
    let kinds: String?
}
