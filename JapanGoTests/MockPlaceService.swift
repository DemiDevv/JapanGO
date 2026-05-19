//
//  MockPlaceService.swift
//  JapanGoTests
//
//  Created by Demain Petropavlov on 19.05.2026.
//

@testable import JapanGo

struct MockPlaceService: PlaceService {
    func getPlaces() async throws -> PlaceData {
        PlaceData(categories: [], regions: [], places: [])
    }
}
