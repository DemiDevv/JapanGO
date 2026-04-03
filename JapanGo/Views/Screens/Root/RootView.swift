//
//  RootView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 31.03.2026.
//

import SwiftUI

struct RootView: View {

    @State private var explorePath = NavigationPath()
    @State private var mapPath = NavigationPath()
    @State private var favoritePath = NavigationPath()
    @State private var profilePath = NavigationPath()
    @State private var selectedTab: Tab = .home
    @Namespace private var tabAnimation

    private var isTabBarHidden: Bool {
        !explorePath.isEmpty || !mapPath.isEmpty || !favoritePath.isEmpty || !profilePath.isEmpty
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            
            Group {
                switch selectedTab {
                case .home:
                    ExploreView(path: $explorePath)
                case .map:
                    MapView()
                case .favorite:
                    FavoriteView()
                case .profile:
                    ProfileView(path: $profilePath)
                }
            }

            if !isTabBarHidden {
                JapanTabBar(
                    selectedTab: $selectedTab,
                    animation: tabAnimation
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isTabBarHidden)
        .background(.blackJG)
    }
}
