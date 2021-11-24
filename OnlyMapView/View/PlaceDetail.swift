//
//  PlaceDetail.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 14.11.2021.
//

import SwiftUI

struct PlaceDetail: View {
    @State var place : Features
    @ObservedObject var detail = Api()
    
    init(place:Features){
        self.place = place
        detail.getData(xid: place.properties.xid)
    }
    
    var body: some View {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(place.properties.name)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    Label("Distance: \(String(Int(place.properties.dist))) m", systemImage: "app.connected.to.app.below.fill")
                        .foregroundColor(.gray)
                        .padding(.bottom, 3)
                    Label("Famous rate: \(place.properties.rate)", systemImage: "star")
                        .foregroundColor(.gray)
                        .padding(.bottom, 3)
                    if (detail.detail != nil){
                        if let imageURL = self.detail.detail!.image{
                            Link(destination:URL(string: imageURL)!){
                                Label("Picture", systemImage: "photo")
                                    .padding(.bottom, 3)
                            }
                        }
                        if let wikiURL = self.detail.detail!.wikipedia{
                            Link(destination:URL(string: wikiURL)!){
                                Label("Wikipedia", systemImage: "link")
                                    .padding(.bottom, 3)
                            }
                        }
                        if let website = self.detail.detail!.url{
                            Link(destination:URL(string: website)!){
                                Label("Website", systemImage: "network")
                                    .padding(.bottom, 3)
                            }
                        }
                    }
                }
                .font(.title3)
                .foregroundColor(.blue)
                .padding(.bottom, 20)
                    Spacer()
                
                if (detail.detail != nil){
                    ScrollView{
                    Text(self.detail.detail!.wikipedia_extracts?.text ?? "Not available")
                    }.padding(.bottom, 10)
                }
                else{
                    Text("notloaded")
                }
Spacer()
                HStack{
                    Button(action: {}){
                        Label("Favorite", systemImage: "heart")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    
                    Spacer()
                    Button(action: {}){
                        Label("Add to trip", systemImage: "map")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
                .padding(.horizontal, 25.0)
            }
            .padding()
        }
}

struct PlaceDetail_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetail(place: Features(type: "type", id: "33", geometry: Geometry(type: "S", coordinates: [32,55]), properties: Properties(xid: "32", name: "Panství", dist: 35.6, rate: 6, osm: nil, wikidata: "Data", kinds: "koozoroh")))
    }
}
