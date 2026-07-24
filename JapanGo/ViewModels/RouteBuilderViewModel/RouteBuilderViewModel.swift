//
//  RouteBuilderViewModel.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 15.04.2026.
//

import SwiftUI
import Combine

enum TravelMode: String, CaseIterable {
    case walking
    case driving
    case transit

    var title: String {
        switch self {
        case .walking: "Walking"
        case .driving: "Driving"
        case .transit: "Transit"
        }
    }

    var icon: String {
        switch self {
        case .walking: "figure.walk"
        case .driving: "car.fill"
        case .transit: "tram.fill"
        }
    }
}

@MainActor
final class RouteBuilderViewModel: ObservableObject {

    @Published var selectedStops: [RouteStop] = []
    @Published var searchResults: [PlaceSuggestion] = []
    @Published var searchText = ""
    @Published var routePolyline: String?
    @Published var travelMode: TravelMode = .walking
    @Published var isSearching = false
    @Published var isBuildingRoute = false
    @Published var routeError: String?

    private let directionsService: DirectionsServiceProtocol
    private let placesSearchService: PlacesSearchServiceProtocol
    var cancellables = Set<AnyCancellable>()

    init(
        directionsService: DirectionsServiceProtocol = DirectionsService(),
        placesSearchService: PlacesSearchServiceProtocol = PlacesSearchService()
    ) {
        self.directionsService = directionsService
        self.placesSearchService = placesSearchService
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.searchPlaces(query: text)
            }
            .store(in: &cancellables)
    }

    func searchPlaces(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }

        isSearching = true

        Task {
            do {
                searchResults = try await placesSearchService.searchPlaces(query: query)
            } catch {
                let nsError = error as NSError
                print("❌ Places search error:")
                print("  Domain: \(nsError.domain)")
                print("  Code: \(nsError.code)")
                print("  Description: \(nsError.localizedDescription)")
                print("  UserInfo: \(nsError.userInfo)")
                searchResults = []
            }
            isSearching = false
        }
    }

    func addStop(from suggestion: PlaceSuggestion) {
        guard !selectedStops.contains(where: { $0.id == suggestion.id }) else { return }

        let stop = RouteStop(
            id: suggestion.id,
            name: suggestion.name,
            address: suggestion.address
        )
        selectedStops.append(stop)

        searchText = ""
        searchResults = []
    }

    func removeStop(_ stop: RouteStop) {
        selectedStops.removeAll { $0.id == stop.id }
    }

    func moveStop(from source: IndexSet, to destination: Int) {
        selectedStops.move(fromOffsets: source, toOffset: destination)
    }

    var canBuildRoute: Bool {
        selectedStops.count >= 2
    }

    func buildRoute() {
        guard canBuildRoute else { return }

        isBuildingRoute = true
        routeError = nil

        Task {
            do {
                let route = try await directionsService.fetchRoute(
                    stops: selectedStops,
                    mode: travelMode
                )
                routePolyline = route.polyline
            } catch {
                let nsError = error as NSError
                print("❌ Directions error:")
                print("  Domain: \(nsError.domain)")
                print("  Code: \(nsError.code)")
                print("  Description: \(nsError.localizedDescription)")
                print("  UserInfo: \(nsError.userInfo)")
                routeError = "Failed to build route"
            }
            isBuildingRoute = false
        }
    }
}
