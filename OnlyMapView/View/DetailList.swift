//
//  DetailList.swift.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 08.12.2021.
//

import SwiftUI

struct DetailList: View {
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var ListOfSavedPlaces: FetchedResults<TripPlaces>

    var arr : FetchedResults<TripLists>.Element
    var body: some View {
            Section(arr.name!){
                List(arr.arrayOfPlaces, id:\.self){ place in
                    NavigationLink(destination:PlaceDetail(place: place)){
                    Text(place.name!)
                    }
                    .swipeActions{
                        Button(action:{
                            withAnimation(.easeInOut){
                                let placeToDelete = ListOfSavedPlaces.first{
                                    $0.id == place.id
                                }
                                moc.delete(placeToDelete!)
                                try? moc.save()
                            }
                        }){
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
            }

        
    }
}

struct DetailList_Previews: PreviewProvider {
    static var previews: some View {
        Text("G")
        //DetailList_swift()
    }
}
