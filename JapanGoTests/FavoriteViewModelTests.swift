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
        #expect(!viewModel.isFavorite(id: addedPlace.id))

        // When
        viewModel.addToFavorite(place: addedPlace)

        // Then
        #expect(viewModel.isFavorite(id: addedPlace.id))
        #expect(viewModel.favoritePlaces.count == existingPlaces.count + 1)
        for place in existingPlaces {
            #expect(viewModel.isFavorite(id: place.id))
        }
    }

    @Test
    func removesOnlySelectedPlaceFromFavorites() {
        // Given
        let places = Place.testPlaces(count: 3)
        let removedPlace = places[1]
        let repository = MockPlaceRepository(favoritePlaces: places)
        let viewModel = FavoriteViewModel(repository: repository)
        #expect(viewModel.isFavorite(id: removedPlace.id))

        // When
        viewModel.removeFromFavorite(id: removedPlace.id)

        // Then
        #expect(!viewModel.isFavorite(id: removedPlace.id))
        #expect(viewModel.favoritePlaces.count == places.count - 1)
        for place in places where place.id != removedPlace.id {
            #expect(viewModel.isFavorite(id: place.id))
        }
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
        let repository = MockPlaceRepository(favoritePlaces: initialPlaces)
        let viewModel = FavoriteViewModel(repository: repository)
        #expect(viewModel.isFavorite(id: place.id) == isInitiallyFavorite)

        // When
        viewModel.toggleFavorite(place: place)

        // Then
        #expect(viewModel.isFavorite(id: place.id) == !isInitiallyFavorite)
        #expect(viewModel.isFavorite(id: otherPlace.id))
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
