//
//  ApiDetailed.swift
//  Tripie
//
//  Created by Jakub Kachlík on 31.10.2021.
//

import Foundation

struct ApiDetailedResponse:Codable{
    let xid : String
    let name : String
    let address: Address?
    let rate : String
    let osm : String?
    let wikidata : String?
    let wikipedia : String?
    let wikipedia_extracts : Extract?
    let kinds: String?
    let image: String?
    let url: String?
    let otm: String?
    let info: Info?
}

struct Extract:Codable{
    let title: String?
    let text : String?
    let html : String?
}

struct Info:Codable{
    let src: String?
    let src_id: String?
    let descr : String?
}

struct Address:Codable{
    let city : String?
    let road: String?
    let house: String?
    let state:String?
    let suburb: String?
    let country:String?
    let postcode:String?
    let country_code: String?
    let house_number: String?
    let state_district: String?
    let city_district: String?
    let neighbourhood: String?
}
