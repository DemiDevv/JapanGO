//
//  SearchFieldView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 29.03.2026.
//

import SwiftUI

struct SearchFieldView: View {

    @Binding var text: String

    var body: some View {
        HStack {
            TextField("", text: $text, prompt: Text("Find your place")
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
    }
}
