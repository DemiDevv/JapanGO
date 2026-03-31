//
//  RootView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 31.03.2026.
//

import SwiftUI

struct RootView: View {

    @State private var selectedTab: Tab = .home
    @Namespace private var tabAnimation

    var body: some View {
        ZStack(alignment: .bottom) {
            
            Group {
                switch selectedTab {
                case .home:
                    ExploreView()
                case .map:
                    MapView()
                case .favorite:
                    FavoriteView()
                case .profile:
                    ProfileView()
                }
            }
            JapanTabBar(
                selectedTab: $selectedTab,
                animation: tabAnimation
            )
        }
    }
}

#Preview {
    RootView()
}
