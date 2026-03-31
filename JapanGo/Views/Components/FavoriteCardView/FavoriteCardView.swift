//
//  FavoriteCardView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 31.03.2026.
//

import SwiftUI

struct FavoriteCardView: View {
    let place: Place

    var body: some View {
        VStack(spacing: 12) {

            HStack(spacing: 12) {

                CachedImageView(url: place.imageURLs.first ?? "")
                    .frame(width: 110, height: 110)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                VStack(alignment: .leading, spacing: 6) {

                    Text(place.name)
                        .font(.system(size: 18, weight: .semibold))
                        .lineLimit(2)

                    Text("\(place.city) • ⭐️ \(String(format: "%.1f", place.rating))")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    Text(place.hours)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()
            }

            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text(place.nearestStation)
                        .font(.system(size: 14, weight: .medium))

                    Text("\(place.walkFromStation) min walk")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

                Spacer()

                Button {
                    // action
                } label: {
                    Text("Open")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [.redJG, .blackGrayJG, .redJG],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

#Preview {
    FavoriteCardView(place: Place.mock)
}
