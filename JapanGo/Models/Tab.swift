//
//  Tab.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 14.03.2026.
//

import Foundation
import SwiftUI

enum Tab: String, CaseIterable {
    case home, map, favorites, profile

    var icon: String {
        switch self {
        case .home: "house"
        case .map: "map"
        case .favorites: "heart"
        case .profile: "person"
        }
    }

    var filledIcon: String {
        switch self {
        case .home: "house.fill"
        case .map: "map.fill"
        case .favorites: "heart.fill"
        case .profile: "person.fill"
        }
    }
}
