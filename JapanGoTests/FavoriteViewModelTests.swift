//
//  FavoriteViewModelTests.swift
//  JapanGoTests
//
//  Created by Demain Petropavlov on 19.05.2026.
//

import Testing
@testable import JapanGo

struct FavoriteViewModelTests {

    @Test(arguments: [0, 1, 3])
    func loadsFavoritesOnInit(favoritesCount: Int) {
        // Given
        let places = Place.testPlaces(count: favoritesCount)
        let repository = MockPlaceRepository(favoritePlaces: places)

        // When
        let viewModel = FavoriteViewModel(repository: repository)

        // Then
        #expect(viewModel.favoritePlaces == places)
    }

    @Test
    func addsPlaceToExistingFavorites() {
        // Given
        let existingPlaces = Place.testPlaces(count: 2, idPrefix: "existing")
        let addedPlace = Place.testPlace(id: "added-place", name: "Added Place")
        let repository = MockPlaceRepository(favoritePlaces: existingPlaces)
        let viewModel = FavoriteViewModel(repository: repository)

        // When
        viewModel.addToFavorite(place: addedPlace)

        // Then
        #expect(viewModel.favoritePlaces == existingPlaces + [addedPlace])
        #expect(viewModel.isFavorite(id: addedPlace.id))
    }

    @Test
    func removesOnlySelectedPlaceFromFavorites() {
        // Given
        let firstPlace = Place.testPlace(id: "first-place", name: "First Place")
        let removedPlace = Place.testPlace(id: "removed-place", name: "Removed Place")
        let lastPlace = Place.testPlace(id: "last-place", name: "Last Place")
        let repository = MockPlaceRepository(favoritePlaces: [firstPlace, removedPlace, lastPlace])
        let viewModel = FavoriteViewModel(repository: repository)

        // When
        viewModel.removeFromFavorite(id: removedPlace.id)

        // Then
        #expect(viewModel.favoritePlaces == [firstPlace, lastPlace])
        #expect(!viewModel.isFavorite(id: removedPlace.id))
    }

    @Test
    func keepsFavoritesWhenRemovingMissingPlace() {
        // Given
        let places = Place.testPlaces(count: 2)
        let repository = MockPlaceRepository(favoritePlaces: places)
        let viewModel = FavoriteViewModel(repository: repository)

        // When
        viewModel.removeFromFavorite(id: "missing-place")

        // Then
        #expect(viewModel.favoritePlaces == places)
    }

    @Test(arguments: [false, true])
    func togglesPlaceFavoriteState(isInitiallyFavorite: Bool) {
        // Given
        let place = Place.testPlace(id: "target-place", name: "Target Place")
        let otherPlace = Place.testPlace(id: "other-place", name: "Other Place")
        let initialPlaces = isInitiallyFavorite ? [otherPlace, place] : [otherPlace]
        let expectedPlaces = isInitiallyFavorite ? [otherPlace] : [otherPlace, place]
        let repository = MockPlaceRepository(favoritePlaces: initialPlaces)
        let viewModel = FavoriteViewModel(repository: repository)

        // When
        viewModel.toggleFavorite(place: place)

        // Then
        #expect(viewModel.favoritePlaces == expectedPlaces)
        #expect(viewModel.isFavorite(id: place.id) == !isInitiallyFavorite)
    }
}

private extension Place {
    static func testPlaces(
        count: Int,
        idPrefix: String = "place"
    ) -> [Place] {
        guard count > 0 else { return [] }

        return (1...count).map {
            testPlace(id: "\(idPrefix)-\($0)", name: "Place \($0)")
        }
    }

    static func testPlace(
        id: String,
        name: String
    ) -> Place {
        Place(
            id: id,
            name: name,
            nameJP: "",
            descriptionEN: "",
            descriptionRU: "",
            category: "",
            rating: 0,
            latitude: 0,
            longitude: 0,
            address: "",
            addressJP: "",
            city: "",
            region: "",
            imageURLs: [],
            price: "",
            hours: "",
            closedDays: nil,
            website: nil,
            phoneNumber: nil,
            nearestStation: "",
            walkFromStation: 0,
            tipsEN: "",
            tipsRU: "",
            tags: [],
            seasonRecommendation: nil
        )
    }
}
