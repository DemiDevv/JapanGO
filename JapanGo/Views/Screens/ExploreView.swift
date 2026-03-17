//
//  ExploreView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 14.03.2026.
//

import SwiftUI

struct ExploreView: View {

    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @StateObject private var exploreViewModel = ExploreViewModel(service: LocalPlaceService())

    var body: some View {

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
            HStack {
                TextField("", text: $searchText, prompt: Text("Find your place")
                    .foregroundStyle(.creamJG))
                .padding(10)

                Button {
                    print("notifications tapped")
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundStyle(.blackJG)
                }
                .padding(10)
                .background {
                    Circle()
                        .foregroundStyle(.creamJG)
                }
            }
            .padding(5)
            .background(Color.blackGrayJG, in: Capsule())
            .padding(.horizontal, 20)
            .padding(.bottom, 5)

            //Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(exploreViewModel.categoryInfo) { category in
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if category.id == selectedCategory {
                                    selectedCategory = nil
                                } else {
                                    selectedCategory = category.id
                                }
                            }
                        } label: {
                            Text(category.nameEN)
                                .foregroundStyle(.whiteJG)
                                .padding(10)
                                .background(Capsule().fill(category.id == selectedCategory ? .redJG : .blackGrayJG))
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
                    print("See all")
                } label: {
                    Text("See all")
                        .foregroundStyle(.whiteJG)
                }

            }
            .padding(.horizontal, 20)

            //PlaceScrollView
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(exploreViewModel.places) { place in
                        PlaceCardView(url: place.imageURLs[0], placeName: place.name, placePrice: place.price, placeDescription: place.descriptionEN)
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
    }
}

#Preview {
    ExploreView()
}
