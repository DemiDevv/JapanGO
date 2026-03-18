//
//  PlaceDetailView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 15.03.2026.
//

import SwiftUI

struct PlaceDetailView: View {

    @Environment(\.dismiss) private var dismiss
    let place: Place

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
                            Button {
                                print("Back")
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.blackJG)
                                    .padding(20)
                                    .background {
                                        Circle()
                                            .foregroundStyle(.whiteJG.opacity(0.8))
                                    }
                            }
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
                        ForEach(CategoryInfo.mockArray) { category in

                                Text(category.nameEN)
                                    .foregroundStyle(.whiteJG)
                                    .padding(10)
                                    .background(Capsule().fill(.blackGrayJG))
                        }
                    }
                    .padding(10)
                }


                Text("\(place.descriptionEN)")
                    .foregroundStyle(.whiteJG)
                    .padding(.leading, 20)

                Button {
                    print("Done")
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
}
