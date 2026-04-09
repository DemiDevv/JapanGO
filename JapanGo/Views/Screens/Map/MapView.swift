//
//  MapView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 31.03.2026.
//

import SwiftUI
import Combine

struct MapView: View {

    @EnvironmentObject var exploreViewModel: ExploreViewModel

    var body: some View {
        VStack {
            GoogleMapView(places: exploreViewModel.places)
        }
        .ignoresSafeArea()
        .background(.blackJG)
    }
}

#Preview {
    @Previewable @StateObject var exploreViewModel = ExploreViewModel(service: LocalPlaceService())
    MapView()
        .environmentObject(exploreViewModel)
}
