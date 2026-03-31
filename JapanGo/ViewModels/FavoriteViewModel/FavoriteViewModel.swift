//
//  FavoriteViewModel.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 30.03.2026.
//

import Foundation
import Combine

final class FavoriteViewModel: ObservableObject {

    @Published var favoritePlaces: [Place] = []

    private var repository: PlaceRepositoryProtocol

    init(repository: PlaceRepositoryProtocol) {
        self.repository = repository
        favoritePlaces = repository.fetchFavorite()
    }

    func addToFavorite(place: Place) {
        repository.addToFavorite(place: place)
        favoritePlaces = repository.fetchFavorite()
    }

    func removeFromFavorite(id: String) {
        repository.removeFromFavorite(id: id)
        favoritePlaces = repository.fetchFavorite()
    }

    func isFavorite(id: String) -> Bool {
        repository.isFavorite(id: id)
    }

    func toggleFavorite(place: Place) {
        if isFavorite(id: place.id) {
            removeFromFavorite(id: place.id)
        } else {
            addToFavorite(place: place)
        }
    }
}
