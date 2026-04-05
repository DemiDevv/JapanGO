//
//  MapView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 31.03.2026.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        VStack {
            GoogleMapView()
        }
        .ignoresSafeArea()
        .background(.blackJG)
    }
}

#Preview {
    MapView()
}
