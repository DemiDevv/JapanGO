//
//  MockPlacesSearchService.swift
//  JapanGoTests
//
//  Created by Demain Petropavlov on 16.07.2026.
//

@testable import JapanGo

final class MockPlacesSearchService: PlacesSearchServiceProtocol {
    private let result: Result<[PlaceSuggestion], Error>
    private(set) var receivedQueries: [String] = []

    init(result: Result<[PlaceSuggestion], Error>) {
        self.result = result
    }

    func searchPlaces(query: String) async throws -> [PlaceSuggestion] {
        receivedQueries.append(query)

        switch result {
        case .success(let suggestions):
            return suggestions
        case .failure(let error):
            throw error
        }
    }
}
