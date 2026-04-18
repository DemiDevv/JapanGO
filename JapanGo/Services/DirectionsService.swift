//
//  DirectionsService.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 18.04.2026.
//

import Foundation

enum DirectionsError: Error {
    case notEnoughStops
    case invalidURL
    case networkError(Error)
    case noRouteFound
    case decodingFailed
}

struct DirectionsRoute {
    let polyline: String
    let totalDuration: String
    let totalDistance: String
}

final class DirectionsService {

    private let apiKey: String

    init(apiKey: String = Configuration.googleDirectionsAPIKey) {
        self.apiKey = apiKey
    }

    func fetchRoute(stops: [RouteStop], mode: TravelMode) async throws -> DirectionsRoute {
        guard stops.count >= 2 else {
            throw DirectionsError.notEnoughStops
        }

        let origin = "place_id:\(stops.first!.id)"
        let destination = "place_id:\(stops.last!.id)"

        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/directions/json")
        guard var components else { throw DirectionsError.invalidURL }

        var queryItems = [
            URLQueryItem(name: "origin", value: origin),
            URLQueryItem(name: "destination", value: destination),
            URLQueryItem(name: "mode", value: mode.rawValue),
            URLQueryItem(name: "key", value: apiKey)
        ]

        if stops.count > 2 {
            let waypoints = stops.dropFirst().dropLast()
                .map { "place_id:\($0.id)" }
                .joined(separator: "|")
            queryItems.append(URLQueryItem(name: "waypoints", value: "optimize:true|\(waypoints)"))
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw DirectionsError.invalidURL
        }

        let data: Data
        do {
            (data, _) = try await URLSession.shared.data(from: url)
        } catch {
            throw DirectionsError.networkError(error)
        }

        if let rawResponse = String(data: data, encoding: .utf8) {
            print("📡 Directions API response: \(rawResponse)")
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let routes = json["routes"] as? [[String: Any]],
              let firstRoute = routes.first else {
            throw DirectionsError.noRouteFound
        }

        guard let polylineDict = firstRoute["overview_polyline"] as? [String: Any],
              let polyline = polylineDict["points"] as? String else {
            throw DirectionsError.decodingFailed
        }

        let legs = firstRoute["legs"] as? [[String: Any]] ?? []
        var totalSeconds = 0
        var totalMeters = 0

        for leg in legs {
            if let duration = leg["duration"] as? [String: Any],
               let value = duration["value"] as? Int {
                totalSeconds += value
            }
            if let distance = leg["distance"] as? [String: Any],
               let value = distance["value"] as? Int {
                totalMeters += value
            }
        }

        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let durationText = hours > 0 ? "\(hours)h \(minutes)min" : "\(minutes)min"

        let distanceKm = Double(totalMeters) / 1000.0
        let distanceText = String(format: "%.1f km", distanceKm)

        return DirectionsRoute(
            polyline: polyline,
            totalDuration: durationText,
            totalDistance: distanceText
        )
    }
}
