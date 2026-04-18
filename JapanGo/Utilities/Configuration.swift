//
//  Configuration.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 18.04.2026.
//

import Foundation

enum Configuration {

    private static let secrets: NSDictionary? = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
            return nil
        }
        return NSDictionary(contentsOfFile: path)
    }()

    static var googleMapsAPIKey: String {
        guard let key = secrets?["GOOGLE_MAPS_API_KEY"] as? String else {
            fatalError("GOOGLE_MAPS_API_KEY not found in Secrets.plist")
        }
        return key
    }

    static var googleDirectionsAPIKey: String {
        guard let key = secrets?["GOOGLE_DIRECTIONS_API_KEY"] as? String else {
            fatalError("GOOGLE_DIRECTIONS_API_KEY not found in Secrets.plist")
        }
        return key
    }
}
