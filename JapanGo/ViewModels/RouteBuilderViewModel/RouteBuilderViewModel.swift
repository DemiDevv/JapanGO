//
//  RouteBuilderViewModel.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 15.04.2026.
//

import Foundation
import Combine
import GooglePlaces

enum TravelMode: String {
    case walking
    case driving
    case transit
}

@MainActor
final class RouteBuilderViewModel: ObservableObject {

    @Published var selectedPlaces: [Place] = []
    @Published var searchResults: [GMSAutocompleteSuggestion] = []
    @Published var searchText = ""
    @Published var routePolyline: String?
    @Published var travelMode: TravelMode = .walking

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
            return
        }

        let filter = GMSAutocompleteFilter()
        filter.countries = ["JP"]

        let request = GMSAutocompleteRequest(query: query)
        request.filter = filter

        placesClient.fetchAutocompleteSuggestions(from: request) { [weak self] results, error in
            guard let results = results, error == nil else { return }
            self?.searchResults = results

        }
    }

    func addPlace(place: Place) {
        guard !selectedPlaces.contains(place) else { return }
        selectedPlaces.append(place)
    }

    func removePlace(place: Place) {
        guard !selectedPlaces.isEmpty else { return }
        selectedPlaces.removeAll {
            $0.id == place.id
        }
    }

    func buildRoute() {
        
    }
}
