//
//  FilterModel.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 11.11.2021.
//

import Foundation
let DEFAULT_LIMIT = 5.0
let DEFAULT_RATE = "1"

enum F_Categ: String {
    case adults = "adult"
    case accomodations = "accomodations"
    case amusements = "amusements"
    case interestingPlaces = "interesting_places"
    case sport = "sport"
    case touristFacilities = "tourist_facilities"
}

struct Filter{
    var rateOptions = ["1","2","3","1h", "2h","3h"]
    var limit = DEFAULT_LIMIT
    var rate = DEFAULT_RATE
    var categories = Categories()
}

struct Categories{
    var adults = false
    var accomodations = false
    var amusements = false
    var interestingPlaces = true
    var sport = false
    var touristFacilities = false
     }
