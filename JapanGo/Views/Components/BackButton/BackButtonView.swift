//
//  BackButtonView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 29.03.2026.
//

import SwiftUI

struct BackButtonView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            print("Back")
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .fontWeight(.bold)
                .foregroundStyle(.blackJG)
                .padding(16)
                .background {
                    Circle()
                        .foregroundStyle(.whiteJG.opacity(0.8))
                }
        }
    }
}

#Preview {
    BackButtonView()
}
