//
//  PlaceService.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 17.03.2026.
//

import Foundation

enum PlaceServiceError: Error {
    case fileNotFound
    case decodingFailed(Error)
}

protocol PlaceService {
    func getPlaces() async throws -> PlaceData
}

final class LocalPlaceService: PlaceService {
    func getPlaces() async throws -> PlaceData {

        guard let url = Bundle.main.url(forResource: "Places", withExtension: "json") else {
            throw PlaceServiceError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        do {
            let places = try JSONDecoder().decode(PlaceData.self, from: data)
            return places
        } catch {
            throw PlaceServiceError.decodingFailed(error)
        }
    }
}
