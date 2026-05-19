//
//  FavoriteViewModelTests.swift
//  JapanGoTests
//
//  Created by Demain Petropavlov on 19.05.2026.
//

import Testing
@testable import JapanGo

struct FavoriteViewModelTests {

    @Test
    func loadsFavoritesOnInit() {
        // Given
        let place = Place.testPlace(id: "1", name: "Mount Fuji")
        let repository = MockPlaceRepository(favoritePlaces: [place])

        // When
        let viewModel = FavoriteViewModel(repository: repository)

        // Then
        #expect(viewModel.favoritePlaces == [place])
    }

    @Test
    func addsPlaceToFavorites() {
        // Given
        let place = Place.testPlace(id: "1", name: "Mount Fuji")
        let repository = MockPlaceRepository()
        let viewModel = FavoriteViewModel(repository: repository)

        // When
        viewModel.addToFavorite(place: place)

        // Then
        #expect(viewModel.favoritePlaces == [place])
        #expect(viewModel.isFavorite(id: place.id))
    }

    @Test
    func removesPlaceFromFavorites() {
        // Given
        let place = Place.testPlace(id: "1", name: "Mount Fuji")
        let repository = MockPlaceRepository(favoritePlaces: [place])
        let viewModel = FavoriteViewModel(repository: repository)

        // When
        viewModel.removeFromFavorite(id: place.id)

        // Then
        #expect(viewModel.favoritePlaces.isEmpty)
        #expect(!viewModel.isFavorite(id: place.id))
    }

    @Test
    func togglesPlaceIntoFavoritesWhenItIsNotFavorite() {
        // Given
        let place = Place.testPlace(id: "1", name: "Mount Fuji")
        let repository = MockPlaceRepository()
        let viewModel = FavoriteViewModel(repository: repository)

        // When
        viewModel.toggleFavorite(place: place)

        // Then
        #expect(viewModel.favoritePlaces == [place])
        #expect(viewModel.isFavorite(id: place.id))
    }

    @Test
    func togglesPlaceOutOfFavoritesWhenItIsFavorite() {
        // Given
        let place = Place.testPlace(id: "1", name: "Mount Fuji")
        let repository = MockPlaceRepository(favoritePlaces: [place])
        let viewModel = FavoriteViewModel(repository: repository)

        // When
        viewModel.toggleFavorite(place: place)

        // Then
        #expect(viewModel.favoritePlaces.isEmpty)
        #expect(!viewModel.isFavorite(id: place.id))
    }
}

private extension Place {
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
