//
//  TripPicker.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 08.12.2021.
//

import SwiftUI

struct TripPicker: View {
    @Environment (\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateAdded)]) var ListOfTrips: FetchedResults<TripLists>
    @FetchRequest(sortDescriptors: []) var ListOfSavedPlaces: FetchedResults<TripPlaces>
    @ObservedObject var TripModel : TripPickerViewModel

    
    init(placeId: PlaceInfos, triplist:FetchedResults<TripLists>){
        self.placeId = placeId
        self.TripModel = TripPickerViewModel(list: triplist)
    }
    
    var placeId : PlaceInfos
    @State private var showingAlert = false
    @State var newTripName = ""
    @State var SelectedList = []

        var body: some View {
            GeometryReader { geometry in
                    ZStack {
                        VStack{
                            List{
                                ForEach(TripModel.TripListModel.OnlyList, id:\.id){ Trip in
                                    Item(name: Trip, selected: TripModel)
                                }
                            }

                        }
                        .zIndex(0)
                            .navigationBarTitle("List of your trips")
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarItems(
                                trailing:
                                    HStack{
                                        Button("+ New"){
                                        withAnimation{
                                            showingAlert.toggle()
                                        }
                                        }//.buttonStyle(.bordered)
                                            //.tint(.blue)
                                        if((TripModel.TripListModel.TripsInList.first{$0.value}) != nil){
                                        Button("Save"){
                                            print("saved")
                                            for list in TripModel.TripListModel.TripsInList{
                                                print(list)
                                                if (list.value){
                                                    let PlaceToSave = TripPlaces(context: moc)
                                                    PlaceToSave.dateAdded = Date()
                                                    PlaceToSave.image = placeId.image
                                                    PlaceToSave.kinds = placeId.kinds
                                                    PlaceToSave.name = placeId.name
                                                    PlaceToSave.rate = placeId.rate
                                                    PlaceToSave.url = placeId.url
                                                    PlaceToSave.wikipedia = placeId.wikipedia
                                                    PlaceToSave.wikipedia_extracts = placeId.description
                                                    PlaceToSave.xid = placeId.xid
                                                    let rest = TripModel.TripListModel.OnlyList.first{$0.id == list.key}
                                                    rest!.addToIsListOf(PlaceToSave)
                                                    PlaceToSave.belongTo!.id = rest!.id
                                                    try? moc.save()

                                                }
                                            }

                                            try? moc.save()
                                            presentationMode.wrappedValue.dismiss()

                                        }
                                        .buttonStyle(.bordered)
                                        .tint(.green)
                                        }
                                        
                                }
                        )
                        
                        if showingAlert{
                            ZStack {
                                HStack{}
                                .frame(width:geometry.size.width, height: geometry.size.height)
                                .background(.ultraThinMaterial)
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
                                                    withAnimation{
                                                        showingAlert.toggle()
                                                    }
                                                    newTripName = ""

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
                
            }
        }
        
                
}
struct Item: View{
    @ObservedObject var name: TripLists
    @ObservedObject var selected: TripPickerViewModel

    var body: some View {
        HStack {
            if (selected.TripListModel.TripsInList[name.id ?? UUID()] ?? false){
                Image(systemName: "checkmark").foregroundColor(.blue)}
            Text(name.name ?? "Unset")
            Spacer()
        }
        .background(Color.white)
        .onTapGesture {
            withAnimation{
                selected.TripListModel.toggle(trip: name.id!)
            }
        }
    }
}


struct TripPicker_Previews: PreviewProvider {
    static var previews: some View {
        Text("none")
        //TripPicker(placeId:)
    }
}
