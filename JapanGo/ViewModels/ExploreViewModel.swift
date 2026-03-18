//
//  ExploreViewModel.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 17.03.2026.
//

import Foundation
import Combine

@MainActor
final class ExploreViewModel: ObservableObject {

    @Published var places: [Place] = []
    @Published var categoryInfo: [CategoryInfo] = []
    @Published var isLoading: Bool = false
    @Published var selectedCategory: String? = nil

    var filteredPlaces: [Place] {
        if selectedCategory == nil {
            return places
        } else {
            return places.filter {
                $0.category == selectedCategory
            }
        }
    }

    var previewPlaces: [Place] {
        return Array(filteredPlaces.prefix(10))
    }
    private let service: PlaceService

    init(service: PlaceService) {
        self.service = service
    }

    func fetchPlaces() async {
        isLoading = true

        do {
            let placeData = try await service.getPlaces()
            places = placeData.places
            categoryInfo = placeData.categories
        } catch {
            print("Error")
        }
        isLoading = false
    }
}
