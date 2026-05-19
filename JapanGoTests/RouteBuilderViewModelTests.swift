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

    @Test
    func cannotBuildRouteWithoutSelectedStops() {
        // Given
        let viewModel = RouteBuilderViewModel()

        // When
        let result = viewModel.canBuildRoute

        // Then
        #expect(!result)
    }

    @Test
    func cannotBuildRouteWithOneSelectedStop() {
        // Given
        let viewModel = RouteBuilderViewModel()
        viewModel.selectedStops = [.testStop(id: "1", name: "Tokyo")]

        // When
        let result = viewModel.canBuildRoute

        // Then
        #expect(!result)
    }

    @Test
    func canBuildRouteWithTwoSelectedStops() {
        // Given
        let viewModel = RouteBuilderViewModel()
        viewModel.selectedStops = [
            .testStop(id: "1", name: "Tokyo"),
            .testStop(id: "2", name: "Kyoto")
        ]

        // When
        let result = viewModel.canBuildRoute

        // Then
        #expect(result)
    }

    @Test
    func removesSelectedStop() {
        // Given
        let viewModel = RouteBuilderViewModel()
        let tokyo = RouteStop.testStop(id: "1", name: "Tokyo")
        let kyoto = RouteStop.testStop(id: "2", name: "Kyoto")
        viewModel.selectedStops = [tokyo, kyoto]

        // When
        viewModel.removeStop(tokyo)

        // Then
        #expect(viewModel.selectedStops == [kyoto])
    }

    @Test
    func movesSelectedStop() {
        // Given
        let viewModel = RouteBuilderViewModel()
        let tokyo = RouteStop.testStop(id: "1", name: "Tokyo")
        let kyoto = RouteStop.testStop(id: "2", name: "Kyoto")
        let osaka = RouteStop.testStop(id: "3", name: "Osaka")
        viewModel.selectedStops = [tokyo, kyoto, osaka]

        // When
        viewModel.moveStop(from: IndexSet(integer: 0), to: 3)

        // Then
        #expect(viewModel.selectedStops == [kyoto, osaka, tokyo])
    }

    @Test
    func clearsSearchStateForEmptyQuery() {
        // Given
        let viewModel = RouteBuilderViewModel()
        viewModel.isSearching = true

        // When
        viewModel.searchPlaces(query: "")

        // Then
        #expect(viewModel.searchResults.isEmpty)
        #expect(!viewModel.isSearching)
    }
}

private extension RouteStop {
    static func testStop(
        id: String,
        name: String
    ) -> RouteStop {
        RouteStop(id: id, name: name, address: "")
    }
}
