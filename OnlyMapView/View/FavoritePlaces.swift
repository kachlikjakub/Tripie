//
//  FavoritePlaces.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 06.11.2021.
//

import SwiftUI

struct FavoritePlaces: View {
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)]) var coreData: FetchedResults<SavedPlaces>
    
    
    var body: some View {
        NavigationView{
        VStack{
            List(coreData){ place in
                NavigationLink(destination: PlaceDetail(DataCore: place)){
                    Text("\(place.name ?? "Not found")")
                        .lineLimit(1)
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
            .navigationTitle("Your favorite places")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FavoritePlaces_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePlaces()
    }
}
