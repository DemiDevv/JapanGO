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
    func returnsAllPlacesWhenCategoryIsNotSelected() {
        // Given
        let viewModel = ExploreViewModel(service: MockPlaceService())
        viewModel.places = TestPlaces.items

        // When
        let result = viewModel.filteredPlaces

        // Then
        #expect(result.count == TestPlaces.items.count)
    }

    @Test
    func filtersPlacesBySelectedCategory() {
        // Given
        let viewModel = ExploreViewModel(service: MockPlaceService())
        viewModel.places = TestPlaces.items

        // When
        viewModel.selectedCategory = "temples"
        let result = viewModel.filteredPlaces

        // Then
        #expect(result.count == 2)
        #expect(result.allSatisfy { $0.category == "temples" })
    }

    @Test
    func filtersPlacesBySearchText() {
        // Given
        let viewModel = ExploreViewModel(service: MockPlaceService())
        viewModel.places = TestPlaces.items

        // When
        viewModel.searchText = "fuji"
        let result = viewModel.filteredPlaces

        // Then
        #expect(result.count == 1)
        #expect(result.first?.name == "Mount Fuji")
    }

    @Test
    func limitsPreviewPlacesToTen() {
        // Given
        let viewModel = ExploreViewModel(service: MockPlaceService())
        viewModel.places = TestPlaces.manyItems

        // When
        let result = viewModel.previewPlaces

        // Then
        #expect(result.count == 10)
    }
}

private struct MockPlaceService: PlaceService {
    func getPlaces() async throws -> PlaceData {
        PlaceData(categories: [], regions: [], places: [])
    }
}

private enum TestPlaces {
    static let items = [
        makePlace(id: "1", name: "Fushimi Inari Taisha", category: "temples"),
        makePlace(id: "2", name: "Senso-ji Temple", category: "temples"),
        makePlace(id: "3", name: "Mount Fuji", category: "nature")
    ]

    static let manyItems = (1...12).map {
        makePlace(id: "\($0)", name: "Place \($0)", category: "temples")
    }

    private static func makePlace(
        id: String,
        name: String,
        category: String
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
