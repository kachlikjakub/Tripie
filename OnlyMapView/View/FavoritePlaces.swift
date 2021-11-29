//
//  FavoritePlaces.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 06.11.2021.
//

import SwiftUI

struct FavoritePlaces: View {
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var coreData: FetchedResults<SavedPlaces>
    
    
    var body: some View {
        NavigationView{
        VStack{
            Text("List")
            List(coreData){ place in
                NavigationLink(destination: NewPlaceDetail(DataCore: place)){
                    Text("\(place.name ?? "Not found") \(place.xid ?? "Not found")")
                }
                .swipeActions{
                    Button(action:{
                        withAnimation(.easeInOut){
                            moc.delete(place)
                            try? moc.save()
                        }
                    }){
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
        }
        .navigationBarHidden(true)
    }
    }
}

struct FavoritePlaces_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePlaces()
    }
}
