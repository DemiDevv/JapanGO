//
//  MockPlaceRepository.swift
//  JapanGoTests
//
//  Created by Demain Petropavlov on 19.05.2026.
//

@testable import JapanGo

final class MockPlaceRepository: PlaceRepositoryProtocol {
    private var favoritePlaces: [Place]

    init(favoritePlaces: [Place] = []) {
        self.favoritePlaces = favoritePlaces
    }

    func addToFavorite(place: Place) {
        guard !isFavorite(id: place.id) else { return }
        favoritePlaces.append(place)
    }

    func removeFromFavorite(id: String) {
        favoritePlaces.removeAll { $0.id == id }
    }

    func fetchFavorite() -> [Place] {
        favoritePlaces
    }

    func isFavorite(id: String) -> Bool {
        favoritePlaces.contains { $0.id == id }
    }
}
