//
//  MapScreen.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 06.11.2021.
//

import SwiftUI
import MapKit

let iphone12Offset :CGFloat = 2.5
let iphone8Offset :CGFloat = 3

struct MapScreen: View {
    @State var FilterModel = FilterViewModel().FilterModel
    @State var MarkersModel = MarkersViewModel().MarkersModel
    @State var MapCoordinates = MapViewModel().MapModel
    @ObservedObject var GottenApiResults = Api()
    var locator = CurrentLocation()


    @State private var defaultOffset : CGFloat = 2.5
    @State var RatingSlider = 50.0
    @State var testMarkers : [Features] = []
    @State var ShownPlace : Features?
    @State var defaultRate : String?
    @State var defaultCategory : String?
    @State var CallLimit : Float = 10.0
    @State var showingAlert = false

    
    var body: some View {
        GeometryReader{ geometry in
            NavigationView{
                ZStack{
                    Map(coordinateRegion: $MapCoordinates.defaultLocation, showsUserLocation: true, annotationItems: GottenApiResults.places, annotationContent: { marker in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(marker.geometry.coordinates[0]), longitude: CLLocationDegrees(marker.geometry.coordinates[1]))){
                            Button(action:{
                                self.ShownPlace = marker
                                self.defaultRate = String(marker.properties.rate)
                                self.defaultCategory = marker.properties.kinds
                                self.GottenApiResults.getData(xid: marker.properties.xid)
                                withAnimation{
                                    MapCoordinates.defaultLocation.center = CLLocationCoordinate2D(latitude: CLLocationDegrees(marker.geometry.coordinates[0]), longitude: CLLocationDegrees(marker.geometry.coordinates[1]))
                                }
                            }){
                                Image(systemName:"mappin.circle")
                                    .font(self.ShownPlace?.properties.xid == marker.properties.xid ? .system(size: 40) : .system(size: 35))
                                .foregroundColor(self.ShownPlace?.properties.xid == marker.properties.xid ? .red : .blue)
                                .background(Color.white)
                                .cornerRadius(.infinity)
                            }
                        }
                    })
                        .ignoresSafeArea()

                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(lineWidth: 5)
                        .cornerRadius(.infinity)
                        .foregroundColor(.blue)
                        .frame(width: geometry.size.width*(RatingSlider/100), height: geometry.size.width*(RatingSlider/100))
                    VStack(alignment:.trailing) {
                        HStack(alignment:.top) {
                            NavigationLink(destination: FilterUI(FilterModel: $FilterModel, Markers: GottenApiResults, MapCoordinates: $MapCoordinates, searchRadius: Int(MapCoordinates.defaultLocation.span.longitudeDelta * 111139 / 3 * (RatingSlider/100))))
                            {
                                Label("Filter", systemImage: "slider.vertical.3")
                            }
                                .font(.title3)
                                .padding(10)
                                .foregroundColor(.blue)
                                .background(Color.white)
                                .cornerRadius(10)
                            Spacer()
                            VStack(alignment:.trailing) {
                                Button(action: {
                                    let searchRadius = Int(MapCoordinates.defaultLocation.span.longitudeDelta * 111139 / 3 * (RatingSlider/100))
                                    GottenApiResults.getData(radius: searchRadius, mapCoordinates: MapCoordinates.defaultLocation.center, filter: FilterModel)
                                })
                                {
                                    Text("Search")
                                        .font(.title3)
                                        .padding(10)
                                        .foregroundColor(.blue)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                }
                                
                                Button(action:{
                                    locator.checkIfLocationIsEnabled()
                                    self.MapCoordinates.defaultLocation = locator.region2
                                }){
                                    Image(systemName: "location")
                                        .font(.title3)
                                        .padding(10)
                                        .foregroundColor(.blue)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                }
                                Spacer()
                                
                                    Slider(value: $RatingSlider, in: 1...100, step:1)
                                        .foregroundColor(.blue)
                                        .rotationEffect(Angle(degrees: 90), anchor: .topTrailing)
                                        .frame(width: geometry.size.height/3)
                                
                                Spacer()
                                
                            }

                        }
                        Spacer()
                    }
                    VStack {
                        Spacer()
                        
                        VStack(alignment:.leading) {
                            ZStack{
                                HStack {
                                    Spacer()
                                    Image(systemName: "ellipsis")
                                        .font(.largeTitle)
                                        .padding([.top, .leading, .trailing], 10)
                                    Spacer()

                                }
                                if((self.ShownPlace) != nil){
                                    HStack{
                                        Spacer()
                                        Button(action:{self.ShownPlace = nil}){
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(Color("CrossButton"))
                                        }
                                    }
                                }
                            }
                            VStack (alignment:.leading) {
                                HStack {
                                    Text((ShownPlace != nil) ? ShownPlace!.properties.name : "No place selected")
                                        .padding(.horizontal)
                                        .padding(.bottom)
                                        .font(.title)
                                        .lineLimit(1)
                                    Spacer()
                                    if(self.ShownPlace != nil){
                                        NavigationLink(destination:LazyView( PlaceDetail(apiRadius: self.ShownPlace!, apiDetail: GottenApiResults))){
                                            Text("Find more")
                                                .font(.title3)
                                                .padding(.horizontal)
                                                .padding(.bottom)
                                        }
                                    }
                                }

                                Text("Place rating (1-7): \((ShownPlace != nil) ? String(ShownPlace!.properties.rate) : "no data")")
                                    .padding(5)
                                Text("Categories: \((ShownPlace != nil) ? ShownPlace!.properties.kinds ?? "Empty" : "no assigned categories")")
                                    .lineLimit(1)
                                    .padding(5)
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height/2)
                        .background(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth:2)
                        )
                        .offset(y: geometry.size.height/defaultOffset)
                        .gesture(DragGesture()

                                    .onEnded({ value in
                            withAnimation{
                                defaultOffset = defaultOffset == 2.5 ? 4.5 : 2.5
                            }
                        }))
                        .onTapGesture(perform: {
                            withAnimation{
                                defaultOffset = defaultOffset == 2.5 ? 4.5 : 2.5
                            }
                        })
                    }
                }
            .navigationBarHidden(true)
            }
        }
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
    }
}
