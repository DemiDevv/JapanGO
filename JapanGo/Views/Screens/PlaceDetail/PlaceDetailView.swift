//
//  PlaceDetailView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 15.03.2026.
//

import SwiftUI

struct PlaceDetailView: View {

    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    let place: Place

    var chips: [(title: String, value: String)] {[
        ("Rating", "\(place.rating)"),
        ("Hours", place.hours),
        ("City", place.city),
        ("Region", place.region)
    ]}

    var body: some View {

        VStack(spacing: -30) {
            CachedImageView(url: place.imageURLs[0])
                .overlay(alignment: .top) {
                    ZStack {
                        Text("\(place.name)")
                            .font(.title)
                            .fontWeight(.bold)
                            .shadow(color: .black.opacity(0.5), radius: 4)
                            .foregroundStyle(.whiteJG)
                        HStack {
                            BackButtonView()

                            Spacer()
                        }
                        .padding(.leading, 20)
                    }
                    .padding(.top, 50)
                }
            //InformationView
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("📍\(place.address)")
                        .font(.title)
                        .foregroundStyle(.whiteJG)

                    Text("\(place.price)")
                        .foregroundStyle(.whiteJG)

                }
                .padding(.top, 20)
                .padding(.leading, 20)

                //Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(chips, id: \.title) { chip in

                            VStack(alignment: .leading, spacing: 4) {
                                Text(chip.title)
                                    .font(.title3)
                                    .foregroundStyle(.grayJG)
                                Text(chip.value)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.whiteJG)

                            }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 20).fill(.blackGrayJG))
                        }
                    }
                    .padding(10)
                }


                Text("\(place.descriptionEN)")
                    .foregroundStyle(.whiteJG)
                    .padding(.leading, 20)

                Button {
                    favoriteViewModel.addToFavorite(place: place)
                } label: {
                    Text("Add to Favorite")
                        .foregroundStyle(.whiteJG)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Capsule().fill(.blackGrayJG))
                }
                .padding(20)
            }
            .frame(maxWidth: .infinity)
            .background(.blackJG)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PlaceDetailView(place: Place.mock)
        .environmentObject(FavoriteViewModel(repository: CoreDataManager()))
}
