//
//  AllPlacesView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 28.03.2026.
//

import SwiftUI

struct AllPlacesView: View {

    let viewTitle: String = "All Places"

    let place: [Place]

    let columns = [
        GridItem(),
        GridItem()
    ]

    var body: some View {

        Text(viewTitle)
            .font(.title2.bold())
            .padding(.vertical, 20)
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(place) { place in
                    PlaceCardView(url: place.imageURLs[0], placeName: place.name, placePrice: place.price, placeDescription: place.descriptionEN,cardWidth: 180, cardheight: 240)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    AllPlacesView(place: Place.mockArray)
}
