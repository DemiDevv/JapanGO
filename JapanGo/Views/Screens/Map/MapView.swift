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
    @State var selectedPlace: Place?

    var body: some View {
        VStack {
            GoogleMapView(places: exploreViewModel.places, selectedPlace: $selectedPlace)
        }
        .ignoresSafeArea()
        .background(.blackJG)
        .fullScreenCover(item: $selectedPlace) { place in
            PlaceDetailView(place: place)
        }
    }
}

#Preview {
    @Previewable @StateObject var exploreViewModel = ExploreViewModel(service: LocalPlaceService())
    MapView()
        .environmentObject(exploreViewModel)
}
