//
//  OnlyMapViewApp.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 06.11.2021.
//

import SwiftUI

@main
struct OnlyMapViewApp: App {
    let data = DataController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, data.container.viewContext)
        }
    }
}
