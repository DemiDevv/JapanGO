//
//  RouteBuilderViewModelTests.swift
//  JapanGoTests
//
//  Created by Demain Petropavlov on 19.05.2026.
//

import Foundation
import Testing
@testable import JapanGo

@MainActor
struct RouteBuilderViewModelTests {

    @Test(arguments: [
        (stopsCount: 0, expectedCanBuildRoute: false),
        (stopsCount: 1, expectedCanBuildRoute: false),
        (stopsCount: 2, expectedCanBuildRoute: true),
        (stopsCount: 5, expectedCanBuildRoute: true)
    ])
    func returnsCanBuildRouteBySelectedStopsCount(
        stopsCount: Int,
        expectedCanBuildRoute: Bool
    ) {
        // Given
        let viewModel = RouteBuilderViewModel()
        viewModel.selectedStops = RouteStop.testStops(count: stopsCount)

        // When
        let result = viewModel.canBuildRoute

        // Then
        #expect(result == expectedCanBuildRoute)
    }

    @Test(arguments: [0, 1])
    func keepsRouteStateWhenBuildRouteCannotStart(stopsCount: Int) {
        // Given
        let directionsService = MockDirectionsService(result: .success(.testRoute))
        let viewModel = RouteBuilderViewModel(directionsService: directionsService)
        viewModel.selectedStops = RouteStop.testStops(count: stopsCount)

        // When
        viewModel.buildRoute()

        // Then
        #expect(!viewModel.isBuildingRoute)
        #expect(viewModel.routeError == nil)
        #expect(viewModel.routePolyline == nil)
        #expect(directionsService.receivedStops.isEmpty)
    }

    @Test
    func buildsRouteWithSelectedStopsAndTravelMode() async {
        // Given
        let expectedRoute = DirectionsRoute(
            polyline: "encoded-polyline",
            totalDuration: "25min",
            totalDistance: "3.2 km"
        )
        let directionsService = MockDirectionsService(result: .success(expectedRoute))
        let viewModel = RouteBuilderViewModel(directionsService: directionsService)
        let stops = RouteStop.testStops(count: 3)
        viewModel.selectedStops = stops
        viewModel.travelMode = .transit

        // When
        viewModel.buildRoute()
        await viewModel.waitForRouteBuild()

        // Then
        #expect(viewModel.routePolyline == expectedRoute.polyline)
        #expect(viewModel.routeError == nil)
        #expect(!viewModel.isBuildingRoute)
        #expect(directionsService.receivedStops == stops)
        #expect(directionsService.receivedMode == .transit)
    }

    @Test
    func setsRouteErrorWhenBuildRouteFails() async {
        // Given
        let directionsService = MockDirectionsService(result: .failure(DirectionsError.noRouteFound))
        let viewModel = RouteBuilderViewModel(directionsService: directionsService)
        let stops = RouteStop.testStops(count: 2)
        viewModel.selectedStops = stops

        // When
        viewModel.buildRoute()
        await viewModel.waitForRouteBuild()

        // Then
        #expect(viewModel.routePolyline == nil)
        #expect(viewModel.routeError == "Failed to build route")
        #expect(!viewModel.isBuildingRoute)
        #expect(directionsService.receivedStops == stops)
    }

    @Test
    func removesOnlySelectedStop() {
        // Given
        let viewModel = RouteBuilderViewModel()
        let stops = RouteStop.testStops(count: 3)
        let removedStop = stops[1]
        viewModel.selectedStops = stops
        #expect(viewModel.selectedStops.contains(removedStop))

        // When
        viewModel.removeStop(removedStop)

        // Then
        #expect(!viewModel.selectedStops.contains(removedStop))
        #expect(viewModel.selectedStops.map(\.id) == [stops[0].id, stops[2].id])
    }

    @Test
    func keepsSelectedStopsWhenRemovingMissingStop() {
        // Given
        let viewModel = RouteBuilderViewModel()
        let stops = RouteStop.testStops(count: 3)
        viewModel.selectedStops = stops

        // When
        viewModel.removeStop(.testStop(id: "missing-stop", name: "Missing Stop"))

        // Then
        #expect(viewModel.selectedStops == stops)
    }

    @Test
    func movesSelectedStop() {
        // Given
        let viewModel = RouteBuilderViewModel()
        let stops = RouteStop.testStops(count: 3)
        viewModel.selectedStops = stops

        // When
        viewModel.moveStop(from: IndexSet(integer: 0), to: 3)

        // Then
        #expect(viewModel.selectedStops == [stops[1], stops[2], stops[0]])
    }

    @Test
    func clearsSearchStateForEmptyQuery() {
        // Given
        let searchService = MockPlacesSearchService(result: .success([]))
        let viewModel = RouteBuilderViewModel(placesSearchService: searchService)
        viewModel.searchResults = PlaceSuggestion.testSuggestions(count: 2)
        viewModel.isSearching = true

        // When
        viewModel.searchPlaces(query: "")

        // Then
        #expect(viewModel.searchResults.isEmpty)
        #expect(!viewModel.isSearching)
        #expect(searchService.receivedQueries.isEmpty)
    }

    @Test
    func loadsSearchResultsForQuery() async {
        // Given
        let suggestions = PlaceSuggestion.testSuggestions(count: 2)
        let searchService = MockPlacesSearchService(result: .success(suggestions))
        let viewModel = RouteBuilderViewModel(placesSearchService: searchService)

        // When
        viewModel.searchPlaces(query: "Tokyo")
        await viewModel.waitForSearch()

        // Then
        #expect(viewModel.searchResults == suggestions)
        #expect(searchService.receivedQueries == ["Tokyo"])
    }

    @Test
    func clearsSearchResultsWhenSearchFails() async {
        // Given
        let searchService = MockPlacesSearchService(result: .failure(TestError()))
        let viewModel = RouteBuilderViewModel(placesSearchService: searchService)
        viewModel.searchResults = PlaceSuggestion.testSuggestions(count: 2)

        // When
        viewModel.searchPlaces(query: "Tokyo")
        await viewModel.waitForSearch()

        // Then
        #expect(viewModel.searchResults.isEmpty)
        #expect(!viewModel.isSearching)
    }

    @Test
    func addsStopFromSuggestionAndClearsSearchState() {
        // Given
        let searchService = MockPlacesSearchService(result: .success([]))
        let viewModel = RouteBuilderViewModel(placesSearchService: searchService)
        let suggestion = PlaceSuggestion.testSuggestion(id: "added-stop", name: "Added Stop")
        viewModel.searchResults = [suggestion]
        viewModel.searchText = "Added"
        #expect(!viewModel.selectedStops.contains(where: { $0.id == suggestion.id }))

        // When
        viewModel.addStop(from: suggestion)

        // Then
        #expect(viewModel.selectedStops.contains(where: { $0.id == suggestion.id }))
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.searchResults.isEmpty)
    }

    @Test
    func skipsDuplicateStopWhenAddingSameSuggestion() {
        // Given
        let searchService = MockPlacesSearchService(result: .success([]))
        let viewModel = RouteBuilderViewModel(placesSearchService: searchService)
        let suggestion = PlaceSuggestion.testSuggestion(id: "added-stop", name: "Added Stop")
        viewModel.addStop(from: suggestion)
        #expect(viewModel.selectedStops.count == 1)

        // When
        viewModel.addStop(from: suggestion)

        // Then
        #expect(viewModel.selectedStops.count == 1)
    }
}

private struct TestError: Error {}

private extension RouteStop {
    static func testStops(
        count: Int,
        idPrefix: String = "stop"
    ) -> [RouteStop] {
        guard count > 0 else { return [] }

        return (1...count).map {
            testStop(id: "\(idPrefix)-\($0)", name: "Stop \($0)")
        }
    }

    static func testStop(
        id: String,
        name: String
    ) -> RouteStop {
        RouteStop(id: id, name: name, address: "")
    }
}

private extension PlaceSuggestion {
    static func testSuggestions(count: Int) -> [PlaceSuggestion] {
        guard count > 0 else { return [] }

        return (1...count).map {
            testSuggestion(id: "suggestion-\($0)", name: "Suggestion \($0)")
        }
    }

    static func testSuggestion(
        id: String,
        name: String
    ) -> PlaceSuggestion {
        PlaceSuggestion(id: id, name: name, address: "")
    }
}

private extension DirectionsRoute {
    static let testRoute = DirectionsRoute(
        polyline: "test-polyline",
        totalDuration: "10min",
        totalDistance: "1.0 km"
    )
}

private extension RouteBuilderViewModel {
    func waitForRouteBuild() async {
        while isBuildingRoute {
            await Task.yield()
        }
    }

    func waitForSearch() async {
        while isSearching {
            await Task.yield()
        }
    }
}
