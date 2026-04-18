//
//  MapView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 31.03.2026.
//

import SwiftUI
import Combine

struct MapView: View {

    @Binding var path: NavigationPath
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    @State var selectedPlace: Place?
    @State private var showRouteBuilder = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                GoogleMapView(places: exploreViewModel.places, selectedPlace: $selectedPlace)
            }
            .ignoresSafeArea()

            Button {
                showRouteBuilder = true
            } label: {
                Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.blackJG)
                    .padding(16)
                    .background(Circle().fill(Color.creamJG))
                    .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 100)
        }
        .background(.blackJG)
        .fullScreenCover(item: $selectedPlace) { place in
            PlaceDetailView(place: place)
        }
        .fullScreenCover(isPresented: $showRouteBuilder) {
            RouteBuilderView(path: $path)
                .environmentObject(exploreViewModel)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    @Previewable @StateObject var exploreViewModel = ExploreViewModel(service: LocalPlaceService())
    MapView(path: $path)
        .environmentObject(exploreViewModel)
}
