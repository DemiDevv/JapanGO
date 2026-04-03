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
        ZStack {
            Color.blackJG.ignoresSafeArea()

            VStack {
                Text("Favorite Places")
                    .foregroundStyle(.whiteJG)

                List {
                    ForEach(favoriteViewModel.favoritePlaces) { place in
                        FavoriteCardView(place: place)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
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
                .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var favoriteViewModel = FavoriteViewModel(repository: CoreDataManager())

    FavoriteView()
        .environmentObject(favoriteViewModel)
}
