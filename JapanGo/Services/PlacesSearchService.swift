//
//  PlacesSearchService.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 16.07.2026.
//

import Foundation
import GooglePlaces

struct PlaceSuggestion: Identifiable, Equatable {
    let id: String
    let name: String
    let address: String
}

protocol PlacesSearchServiceProtocol {
    func searchPlaces(query: String) async throws -> [PlaceSuggestion]
}

final class PlacesSearchService: PlacesSearchServiceProtocol {

    private let placesClient = GMSPlacesClient.shared()

    func searchPlaces(query: String) async throws -> [PlaceSuggestion] {
        let filter = GMSAutocompleteFilter()
        filter.countries = ["JP"]

        let request = GMSAutocompleteRequest(query: query)
        request.filter = filter

        let suggestions: [GMSAutocompleteSuggestion] = try await withCheckedThrowingContinuation { continuation in
            placesClient.fetchAutocompleteSuggestions(from: request) { results, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: results ?? [])
                }
            }
        }

        return suggestions.compactMap { suggestion in
            guard let placeSuggestion = suggestion.placeSuggestion else { return nil }

            return PlaceSuggestion(
                id: placeSuggestion.placeID,
                name: placeSuggestion.attributedPrimaryText.string,
                address: placeSuggestion.attributedSecondaryText?.string ?? ""
            )
        }
    }
}
