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
    @Published var searchText = ""

    var cancellables = Set<AnyCancellable>()


    var filteredPlaces: [Place] {
        places
            .filter { selectedCategory == nil || $0.category == selectedCategory }
            .filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var previewPlaces: [Place] {
        return Array(filteredPlaces.prefix(10))
    }
    private let service: PlaceService

    init(service: PlaceService) {
        self.service = service
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { print("Пользователь начал вводить: \($0)") }
            .store(in: &cancellables)
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
