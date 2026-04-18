//
//  RouteBuilderViewModel.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 15.04.2026.
//

import SwiftUI
import Combine
import GooglePlaces

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
    @Published var searchResults: [GMSAutocompleteSuggestion] = []
    @Published var searchText = ""
    @Published var routePolyline: String?
    @Published var travelMode: TravelMode = .walking
    @Published var isSearching = false

    private let placesClient = GMSPlacesClient.shared()
    var cancellables = Set<AnyCancellable>()

    init() {
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

        let filter = GMSAutocompleteFilter()
        filter.countries = ["JP"]

        let request = GMSAutocompleteRequest(query: query)
        request.filter = filter

        placesClient.fetchAutocompleteSuggestions(from: request) { [weak self] results, error in
            guard let self else { return }
            self.isSearching = false

            if let error {
                let nsError = error as NSError
                print("❌ Places search error:")
                print("  Domain: \(nsError.domain)")
                print("  Code: \(nsError.code)")
                print("  Description: \(nsError.localizedDescription)")
                print("  UserInfo: \(nsError.userInfo)")
                self.searchResults = []
                return
            }

            guard let results else {
                self.searchResults = []
                return
            }

            self.searchResults = results
        }
    }

    func addStop(from suggestion: GMSAutocompleteSuggestion) {
        guard let placeSuggestion = suggestion.placeSuggestion else { return }

        let placeID = placeSuggestion.placeID
        guard !selectedStops.contains(where: { $0.id == placeID }) else { return }

        let name = placeSuggestion.attributedPrimaryText.string
        let address = placeSuggestion.attributedSecondaryText?.string ?? ""

        let stop = RouteStop(id: placeID, name: name, address: address)
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

    }
}
