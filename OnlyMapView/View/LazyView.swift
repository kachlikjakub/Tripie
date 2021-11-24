//
//  LazyView.swift
//  OnlyMapView
//
//  Created by Jakub Kachlík on 15.11.2021.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
