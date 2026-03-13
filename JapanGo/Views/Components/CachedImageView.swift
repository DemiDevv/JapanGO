//
//  CachedImageView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 13.03.2026.
//

import SwiftUI
import Kingfisher

struct CachedImageView: View {

    let url: String

    var body: some View {
        KFImage(URL(string: url))
            .placeholder {
                ProgressView()
            }
            .fade(duration: 0.3)
            .resizable()
            .scaledToFill()
    }
}

#Preview {
    CachedImageView(url: Place.mock.imageURLs[0])
}
