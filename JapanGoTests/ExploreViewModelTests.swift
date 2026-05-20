//
//  ExploreViewModelTests.swift
//  JapanGoTests
//
//  Created by Demain Petropavlov on 18.05.2026.
//

import Testing
@testable import JapanGo

@MainActor
struct ExploreViewModelTests {

    @Test
    func returnsAllPlacesByDefault() {
        // Given
        let viewModel = ExploreViewModel(service: MockPlaceService())
        let places = Place.testPlaces(count: 3)
        viewModel.places = places

        // When
        let result = viewModel.filteredPlaces

        // Then
        #expect(result == places)
    }

    @Test
    func returnsAllPlacesWhenCategoryIsNil() {
        // Given
        let viewModel = ExploreViewModel(service: MockPlaceService())
        let places = Place.testPlaces(count: 3)
        viewModel.places = places

        // When
        viewModel.selectedCategory = "temples"
        viewModel.selectedCategory = nil
        let result = viewModel.filteredPlaces

        // Then
        #expect(result == places)
    }

    @Test
    func filtersPlacesBySelectedCategory() {
        // Given
        let viewModel = ExploreViewModel(service: MockPlaceService())
        let templePlaces = Place.testPlaces(count: 3, category: "temples")
        let naturePlaces = Place.testPlaces(count: 2, category: "nature")
        viewModel.places = templePlaces + naturePlaces

        // When
        viewModel.selectedCategory = "temples"
        let result = viewModel.filteredPlaces

        // Then
        #expect(result == templePlaces)
    }

    @Test
    func filtersPlacesBySearchText() {
        // Given
        let viewModel = ExploreViewModel(service: MockPlaceService())
        let expectedPlace = Place.testPlace(id: "1", name: "Mount Fuji")
        viewModel.places = [
            expectedPlace,
            .testPlace(id: "2", name: "Senso-ji Temple"),
            .testPlace(id: "3", name: "Fushimi Inari Taisha")
        ]

        // When
        viewModel.searchText = "fuji"
        let result = viewModel.filteredPlaces

        // Then
        #expect(result == [expectedPlace])
    }

    @Test(arguments: [
        (placesCount: 0, expectedCount: 0),
        (placesCount: 1, expectedCount: 1),
        (placesCount: 10, expectedCount: 10),
        (placesCount: 11, expectedCount: 10),
        (placesCount: 100, expectedCount: 10)
    ])
    func limitsPreviewPlacesToTen(
        placesCount: Int,
        expectedCount: Int
    ) {
        // Given
        let viewModel = ExploreViewModel(service: MockPlaceService())
        viewModel.places = Place.testPlaces(count: placesCount)

        // When
        let result = viewModel.previewPlaces

        // Then
        #expect(result.count == expectedCount)
    }
}

private extension Place {
    static func testPlaces(
        count: Int,
        category: String = "temples"
    ) -> [Place] {
        guard count > 0 else { return [] }

        return (1...count).map {
            testPlace(id: "\($0)", name: "Place \($0)", category: category)
        }
    }

    static func testPlace(
        id: String,
        name: String,
        category: String = "temples"
    ) -> Place {
        Place(
            id: id,
            name: name,
            nameJP: "",
            descriptionEN: "",
            descriptionRU: "",
            category: category,
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
