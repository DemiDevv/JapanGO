//
//  PlaceCardView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 08.03.2026.
//

import SwiftUI

struct PlaceCardView: View {

    let url: String
    let placeName: String
    let placePrice: String
    let placeDescription: String
    let cardWidth: CGFloat
    let cardheight: CGFloat

    var body: some View {
        CachedImageView(url: url)
            .frame(width: cardWidth, height: cardheight)
            .overlay(alignment: .bottom) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(placeName)
                            .font(.title3)
                            .fontWeight(.bold)

                        Spacer()

                        Text(placePrice)
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }

                    Text(placeDescription)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(4)
                }
                .foregroundStyle(.white)
                .padding(10)
                .padding(.bottom, 20)
                .background(alignment: .bottom) {
                    CachedImageView(url: url)
                        .frame(width: cardWidth, height: cardheight)
                        .blur(radius: 3)
                }
                .clipped()
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    PlaceCardView(
        url: Place.mock.imageURLs[0],
        placeName: Place.mock.name,
        placePrice: Place.mock.price,
        placeDescription: Place.mock.descriptionEN,
        cardWidth: 300,
        cardheight: 400
    )
}
