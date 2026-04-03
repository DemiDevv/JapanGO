//
//  JapanTabBar.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 14.03.2026.
//

import SwiftUI

struct JapanTabBar: View {
    @Binding var selectedTab: Tab
    var animation: Namespace.ID

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Tab.allCases, id: \.self) { tab in
                let isSelected = selectedTab == tab

                Button {
                    haptic(.light)
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: isSelected ? tab.filledIcon : tab.icon)
                            .font(.system(size: 18))
                    }
                    .foregroundStyle(isSelected ? .blackJG : .whiteJG)
                    .padding(.horizontal, isSelected ? 26 : 10)
                    .padding(.vertical, 10)
                    .background {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.whiteJG)
                                .matchedGeometryEffect(id: "PILL_BG", in: animation)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(
            Capsule()
                .foregroundStyle(.blackGrayJG)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 0)
    }
}

#Preview {
    @Previewable @Namespace var ns
    @Previewable @State var tab: Tab = .home

    ZStack(alignment: .bottom) {
        Color(.blackJG).ignoresSafeArea()

        JapanTabBar(
            selectedTab: $tab,
            animation: ns
        )
    }
}

