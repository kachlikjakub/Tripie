//
//  PlaceDetail.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 14.11.2021.
//

import SwiftUI


struct PlaceInfos{
    var xid : String
    var name : String
    var coordinate : [Float]
    var dist : Float?
    var rate : Int16
    var osm : String?
    var description : String?
    var wikipedia : String?
    var url : String?
    var image : String?
    var kinds: String?
    
}

struct PlaceDetail: View {
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var FavoriteSavedPlaces: FetchedResults<SavedPlaces>
    @FetchRequest(sortDescriptors: []) var ListOfTrips: FetchedResults<TripLists>
    @FetchRequest(sortDescriptors: []) var ListOfSavedPlaces: FetchedResults<TripPlaces>
    var place : PlaceInfos
    
    init(apiRadius: Features, apiDetail:Api){
        let prop = apiRadius.properties
        place = PlaceInfos(
            xid: apiRadius.properties.xid,
            name: prop.name,
            coordinate: apiRadius.geometry.coordinates,
            rate: Int16(prop.rate),
            description: apiDetail.detail!.wikipedia_extracts?.text ?? "No description",
            wikipedia: apiDetail.detail!.wikipedia,
            url: apiDetail.detail!.url,
            image: apiDetail.detail!.image,
            kinds: prop.kinds)
    }
    
    init(DataCore: FetchedResults<SavedPlaces>.Element){
        place = PlaceInfos(
            xid: DataCore.xid!,
            name: DataCore.name!,
            coordinate: [14,15],
            rate: DataCore.rate,
            description: DataCore.wikipedia_extracts,
            wikipedia: DataCore.wikipedia,
            url: DataCore.url,
            image: DataCore.image,
            kinds: DataCore.kinds)
    }
    
    init(place:TripPlaces){
        self.place = PlaceInfos(
            xid: place.xid!,
            name: place.name!,
            coordinate: [14,15],
            rate: place.rate,
            description: place.wikipedia_extracts,
            wikipedia: place.wikipedia,
            url: place.url,
            image: place.image,
            kinds: place.kinds)
    }
    
    var body: some View {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.largeTitle)
                        .foregroundColor(.black)

                    Label("Famous rate: \(place.rate)", systemImage: "star")
                        .foregroundColor(.gray)
                        .padding(.bottom, 3)
                    
                        if let imageURL = self.place.image{
                            Link(destination:URL(string: imageURL)!){
                                Label("Picture", systemImage: "photo")
                                    .padding(.bottom, 3)
                            }
                        }
                        if let wikiURL = self.place.wikipedia{
                            Link(destination:URL(string: wikiURL)!){
                                Label("Wikipedia", systemImage: "link")
                                    .padding(.bottom, 3)
                            }
                        }
                        if let website = self.place.url{
                            Link(destination:( URL(string: website)!)){
                                Label("Website", systemImage: "network")
                                    .padding(.bottom, 3)
                            }
                        }
                    
                }
                .font(.title3)
                .foregroundColor(.blue)
                .padding(.bottom, 20)
                    Spacer()
                
                
                    ScrollView{
                    Text(self.place.description ?? "No description available")
                    }.padding(.bottom, 10)

Spacer()
                HStack{
                    Button(action: {
                        if (FavoriteSavedPlaces.contains{$0.xid == place.xid}){
                            let elementToDelete = FavoriteSavedPlaces.first{$0.xid == place.xid}
                            moc.delete(elementToDelete!)
                            
                            try? moc.save()
                        }
                        else{
                            let FavPlaceToSave = SavedPlaces(context: moc)
                            FavPlaceToSave.dateAdded = Date()
                            FavPlaceToSave.rate = Int16(place.rate)
                            FavPlaceToSave.name = place.name
                            FavPlaceToSave.xid = place.xid
                            FavPlaceToSave.wikipedia_extracts = self.place.description
                            FavPlaceToSave.url = self.place.url
                            FavPlaceToSave.image = self.place.image
                            FavPlaceToSave.wikipedia = self.place.wikipedia

                            try? moc.save()
                        }
                    }){
                        FavoriteSavedPlaces.contains{$0.xid == place.xid} ?
                            Label("Unfavorite", systemImage: "heart.fill") :
                            Label("Favorite", systemImage: "heart")

                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    
                    Spacer()
                    
                    NavigationLink(destination: TripPicker(placeId:place, triplist:ListOfTrips)){
                        Label("Add to trip", systemImage: "map")
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 25.0)
            }
            .navigationTitle("")
            .padding()
        }
}

struct NewPlaceDetail_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetail(
            apiRadius: Features(type: "type", id: "33", geometry: Geometry(type: "S", coordinates: [32,55]), properties: Properties(xid: "32", name: "Panství", dist: 35.6, rate: 6, osm: nil, wikidata: "Data", kinds: "koozoroh")),
            apiDetail: Api())
    }
}
