//
//  ExploreView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 14.03.2026.
//

import SwiftUI

struct ExploreView: View {

    @State private var path = NavigationPath()
    @StateObject private var exploreViewModel = ExploreViewModel(service: LocalPlaceService())
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel

    var body: some View {

        NavigationStack(path: $path) {

            VStack {

                //Avatar Name Button
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.whiteJG)

                    VStack(alignment: .leading) {
                        Text("Good to see you,")
                            .font(.subheadline)
                            .foregroundStyle(.whiteJG)
                        Text("Demian Petropavlov")
                            .foregroundStyle(.whiteJG)
                            .font(.title2)
                            .fontWeight(.bold)
                    }

                    Spacer()

                    Button {
                        print("notifications tapped")
                    } label: {
                        Image(systemName: "bell")
                            .font(.system(size: 20))
                            .foregroundStyle(.whiteJG)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

                //TextField

                SearchFieldView(text: $exploreViewModel.searchText)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)

                //Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(exploreViewModel.categoryInfo) { category in
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if category.id == exploreViewModel.selectedCategory {
                                        exploreViewModel.selectedCategory = nil
                                    } else {
                                        exploreViewModel.selectedCategory = category.id
                                    }
                                }
                            } label: {
                                Text(category.nameEN)
                                    .foregroundStyle(.whiteJG)
                                    .padding(10)
                                    .background(Capsule().fill(category.id == exploreViewModel.selectedCategory ? .redJG : .blackGrayJG))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }

                //Header
                HStack {
                    Text("Places")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.whiteJG)

                    Spacer()

                    Button {
                        path.append(Route.allPlaces)
                    } label: {
                        Text("See all")
                            .foregroundStyle(.whiteJG)
                    }

                }
                .padding(.horizontal, 20)

                //PlaceScrollView
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(exploreViewModel.previewPlaces) { place in
                            PlaceCardView(url: place.imageURLs[0], placeName: place.name, placePrice: place.price, placeDescription: place.descriptionEN,cardWidth: 300, cardheight: 400, isFavorite: favoriteViewModel.isFavorite(id: place.id)) {
                                favoriteViewModel.toggleFavorite(place: place)
                                print("Like")
                            }
                            .onTapGesture {
                                path.append(Route.placeDetail(place))
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                }

                Spacer()
            }
            .task {
                await exploreViewModel.fetchPlaces()
            }
            .background(.blackJG)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .placeDetail(let place):
                    PlaceDetailView(place: place)
                case .allPlaces:
                    AllPlacesView(viewModel: exploreViewModel, path: $path)
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var favoriteViewModel = FavoriteViewModel(repository: CoreDataManager())

    ExploreView()
        .environmentObject(favoriteViewModel)
}
