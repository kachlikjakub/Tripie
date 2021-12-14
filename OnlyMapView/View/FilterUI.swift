//
//  FilterUI.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 10.11.2021.
//

import SwiftUI
import MapKit

@available(iOS 15.0, *)
struct FilterUI: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var FilterModel : Filter
    var Markers : Api
    @Binding var MapCoordinates : MapCoordinates
    @State var searchRadius : Int
    
    var body: some View {
            VStack {
                List{
                    
                    Section("Number of results") {
                        HStack{
                            Slider(value: $FilterModel.limit, in: 1...50, step: 1)
                            Text(String(Int(FilterModel.limit)))
                        }
                    }
                
                    Section(header:Text("FAMOUS RATE"), footer:Text("h - cultural heritage")){
                        Picker("Minimum famous rate", selection: $FilterModel.rate){
                            ForEach(FilterModel.rateOptions, id:\.self){
                                Text($0)
                            }
                        }.pickerStyle(.segmented)
                        
                    }.textCase(nil)
                    //Section ("Category of places") {
                        HStack {
                            Button(action:{
                                withAnimation{
                                    FilterModel.categories.adults = true
                                    FilterModel.categories.accomodations = true
                                    FilterModel.categories.amusements = true
                                    FilterModel.categories.interestingPlaces = true
                                    FilterModel.categories.sport = true
                                    FilterModel.categories.touristFacilities = true
                                }
                            }){
                                Text("Select all")
                                    .foregroundColor(.blue)
                            }.buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            Button(action:{
                                withAnimation{
                                    FilterModel.categories.adults = false
                                    FilterModel.categories.accomodations = false
                                    FilterModel.categories.amusements = false
                                    FilterModel.categories.interestingPlaces = false
                                    FilterModel.categories.sport = false
                                    FilterModel.categories.touristFacilities = false
                                }
                            }){
                                Text("Unselect all")
                                    .foregroundColor(.red)
                            }.buttonStyle(PlainButtonStyle())
                        }
                        VStack {
                        Toggle("Adults / Clubs", isOn: $FilterModel.categories.adults)
                        Toggle("Accomodation", isOn: $FilterModel.categories.accomodations)
                        Toggle("Amusements", isOn: $FilterModel.categories.amusements)
                        Toggle("Interesting places", isOn: $FilterModel.categories.interestingPlaces)
                        Toggle("Sport", isOn: $FilterModel.categories.sport)
                        Toggle("Tourist facilites", isOn: $FilterModel.categories.touristFacilities)
                        }
                    //}
                }//.listStyle(.insetGrouped)
            }

    
        .navigationTitle("Filter")
        .navigationBarItems(trailing: Button(action:{
            Markers.places = []
            Markers.getData(radius: searchRadius, mapCoordinates: MapCoordinates.defaultLocation.center, filter: FilterModel)
            self.mode.wrappedValue.dismiss()
        }){
            Text("Apply")
        })
}

}

@available(iOS 15.0, *)
struct FilterUI_Previews: PreviewProvider {
    static var previews: some View {
        FilterUI(FilterModel: .constant(Filter()), Markers: Api(), MapCoordinates: .constant(MapCoordinates(defaultLocation: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.075539, longitude: 14.437800), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))), searchRadius: 50)
    }
}
