//
//  ApiCall.swift
//  Tripie
//
//  Created by Jakub Kachlík on 24.10.2021.
//

import Foundation
import MapKit
import Combine

class Api : ObservableObject{
    @Published var places : [Features]
    @Published var detail : ApiDetailedResponse?
    
    var cancellable: Cancellable? = nil
    init(){
        self.places = []
    }
    
    enum LoadErr: Error {
        case invalidURL
        case missingData
    }
    
    let LoadPlacesURL = "https://api.opentripmap.com/0.1/en/places/radius?"
    let LoadDetailPlaceURL = "https://api.opentripmap.com/0.1/en/places/xid/"
    let DefaultAPIKey = "5ae2e3f221c38a28845f05b6d8852d7cc0e894fa7e45aa19666b1410"
    
    func getData(radius:Int, mapCoordinates: CLLocationCoordinate2D, filter:Filter){
        let wholeURL = LoadPlacesURL + "radius=\(radius)&" + "lon=\(mapCoordinates.longitude)&" + "lat=\(mapCoordinates.latitude)&" + "rate=3h&" + "limit=\(Int(filter.limit))&" + "apikey=\(DefaultAPIKey)"
        let url = URL(string: wholeURL)!
        cancellable?.cancel()
        cancellable = URLSession(configuration: .default)
            .dataTaskPublisher(for: url)
            .tryMap(){ element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else{
                          throw URLError(.badServerResponse)
                      }
                return element.data
            }
            .decode(type: ApiRadiusAnswer.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print("sinked \($0)")
            }, receiveValue: {[weak self] place in
                self?.places = []
                    place.features.forEach{ place in
                        self?.places.append(Features(type: place.type, id: place.id, geometry: Geometry(type: place.geometry.type, coordinates: [place.geometry.coordinates[1],place.geometry.coordinates[0]]), properties: Properties(xid: place.properties.xid, name: place.properties.name, dist: place.properties.dist, rate: place.properties.rate, osm: place.properties.osm, wikidata: place.properties.wikidata, kinds: place.properties.kinds)))
                    }
            })
    }
    
    func getData(xid: String){
        let wholeURL = LoadDetailPlaceURL + "\(xid)?" + "apikey=\(DefaultAPIKey)"
        let url = URL(string: wholeURL)!
        cancellable?.cancel()
        cancellable = URLSession(configuration: .default)
            .dataTaskPublisher(for: url)
            .tryMap(){ element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else{
                          throw URLError(.badServerResponse)
                      }
                print(element.data)
                return element.data
            }
            .decode(type: ApiDetailedResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print("sinked \($0)")
            }, receiveValue: {[weak self] place in
                print(xid)
                print(place)
                self?.detail = place
            })
    }
}
