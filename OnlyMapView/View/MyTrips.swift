//
//  MyTrips.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 06.11.2021.
//

import SwiftUI

struct MyTrips: View {
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var coreData: FetchedResults<TripLists>
    @FetchRequest(sortDescriptors: []) var tripPlaces: FetchedResults<TripPlaces>
    @State var newTripName = ""
    @State private var showingAlert = false

    
    var body: some View {
        GeometryReader{ geometry in
        NavigationView{
        ZStack {
            List(coreData){ place in
                NavigationLink(destination:DetailList(arr: place)){
                Text(place.name ?? "No text found")
            }
                .swipeActions{
                    Button(action:{
                        withAnimation(.easeInOut){
                            for eachplace in place.arrayOfPlaces {
                                moc.delete(eachplace)
                            }
                            moc.delete(place)
                            try? moc.save()
                        }
                    }){
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
            if showingAlert{
                ZStack {
                    HStack{}
                    .frame(width:geometry.size.width, height: geometry.size.height)
                    .background(Color.black)
                    .opacity(0.3)
                    HStack {
                            VStack {
                                Text("Create new trip")
                                TextField("New trip", text: $newTripName)
                                    .padding(.horizontal, 8)

                                    .background(Color.white)
                                    .cornerRadius(4)
                                    .padding(.bottom, 10)

                                HStack {
                                    Spacer()
                                    Button("Add"){
                                        withAnimation{
                                            showingAlert.toggle()
                                        }
                                        
                                        let newTrip = TripLists(context: moc)
                                        newTrip.name = newTripName
                                        newTrip.id = UUID()
                                        newTrip.dateAdded = Date()
                                        newTripName = ""

                                        try? moc.save()
                                    }
                                    .disabled(newTripName == "")
                                    Spacer()
                                    Spacer()
                                    Button("Cancel"){
                                        newTripName = ""
                                        withAnimation{
                                            showingAlert.toggle()
                                        }
                                    }
                                        .tint(.red)
                                    Spacer()
                                }
                            }
                        }
                        .frame(width:geometry.size.width/1.5, height: geometry.size.height/8)
                        .padding()
                        .background(
                            RadialGradient(colors: [Color("NavBgMiddle"), Color("NavBg")], center: .center, startRadius: 1, endRadius: 500)
                        )
                    .cornerRadius(12)
                }
                .zIndex(1)
                //.transition(.slide)
            }

        }
        .navigationBarItems(trailing:
                                Button(action:{showingAlert.toggle()}){
            Text("+ New ")
                .lineLimit(2)
        }//.buttonStyle(.bordered)
                                .tint(.blue))
        .navigationTitle(Text("Your trips"))
        .navigationBarTitleDisplayMode(.inline)
        }
        }
    }
}

struct MyTrips_Previews: PreviewProvider {
    static var previews: some View {
        MyTrips()
    }
}
