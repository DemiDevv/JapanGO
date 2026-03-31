//
//  FavoriteView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 31.03.2026.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel

    var body: some View {
        VStack {
            Text("Favorite Places")

            List {
                ForEach(favoriteViewModel.favoritePlaces) { place in
                    FavoriteCardView(place: place)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                favoriteViewModel.removeFromFavorite(id: place.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)

        }
    }
}

#Preview {
    @Previewable @StateObject var favoriteViewModel = FavoriteViewModel(repository: CoreDataManager())

    FavoriteView()
        .environmentObject(favoriteViewModel)
}
