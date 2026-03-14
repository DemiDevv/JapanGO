//
//  ExploreView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 14.03.2026.
//

import SwiftUI

struct ExploreView: View {

    @State private var searchText = ""

    var body: some View {

        //Avatar Name Button
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.blackGrayJG)

            VStack(alignment: .leading) {
                Text("Good to see you,")
                    .font(.subheadline)
                Text("Demian Petropavlov")
                    .font(.title2)
                    .fontWeight(.bold)
            }

            Spacer()

            Button {
                print("notifications tapped")
            } label: {
                Image(systemName: "bell")
                    .font(.system(size: 20))
                    .foregroundStyle(.blackJG)
            }
        }
        .padding(.trailing, 20)
        .padding(.leading, 20)

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
        .padding(.trailing, 20)
        .padding(.leading, 20)
    }
}

#Preview {
    ExploreView()
}
