//
//  PlaceDetailView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 15.03.2026.
//

import SwiftUI

struct PlaceDetailView: View {

    let url = Place.mock.imageURLs[0]

    var body: some View {
            CachedImageView(url: url)
                .ignoresSafeArea()
                .overlay(alignment: .top) {

                    ZStack {
                        Text("Title")
                            .font(.title)

                        HStack {
                            Button {
                                print("Back")
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.blackJG)
                                    .padding(20)
                                    .background {
                                        Circle()
                                            .foregroundStyle(.creamJG.opacity(0.8))
                                    }
                            }

                            Spacer()
                        }
                        .padding(.leading, 20)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                }
    }
}

#Preview {
    PlaceDetailView()
}
