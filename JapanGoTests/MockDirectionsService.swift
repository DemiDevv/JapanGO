//
//  MockDirectionsService.swift
//  JapanGoTests
//
//  Created by Demain Petropavlov on 25.05.2026.
//

@testable import JapanGo

final class MockDirectionsService: DirectionsServiceProtocol {
    private let result: Result<DirectionsRoute, Error>
    private(set) var receivedStops: [RouteStop] = []
    private(set) var receivedMode: TravelMode?

    init(result: Result<DirectionsRoute, Error>) {
        self.result = result
    }

    func fetchRoute(stops: [RouteStop], mode: TravelMode) async throws -> DirectionsRoute {
        receivedStops = stops
        receivedMode = mode

        switch result {
        case .success(let route):
            return route
        case .failure(let error):
            throw error
        }
    }
}
