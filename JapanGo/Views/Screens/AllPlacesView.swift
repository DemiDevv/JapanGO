//
//  AllPlacesView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 28.03.2026.
//

import SwiftUI

struct AllPlacesView: View {

    @ObservedObject var viewModel: ExploreViewModel
    @Binding var path: NavigationPath

    let viewTitle: String = "All Places"

    let columns = [
        GridItem(),
        GridItem()
    ]

    var body: some View {

            VStack {
                ZStack {
                    Text(viewTitle)
                        .font(.title2.bold())
                        .foregroundStyle(.whiteJG)
                        .padding(.vertical, 20)

                    HStack{
                        BackButtonView()
                        .padding(.leading, 20)

                        Spacer()
                    }
                }

                SearchFieldView(text: $viewModel.searchText)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.previewPlaces) { place in
                            PlaceCardView(url: place.imageURLs[0], placeName: place.name, placePrice: place.price, placeDescription: place.descriptionEN,cardWidth: 180, cardheight: 240)
                                .onTapGesture {
                                    path.append(Route.placeDetail(place))
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(.blackJG)
    }
}
