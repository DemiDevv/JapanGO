//
//  RouteBuilderView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 15.04.2026.
//

import SwiftUI

struct RouteBuilderView: View {

    @Binding var path: NavigationPath
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    @StateObject var routeBuilderViewModel = RouteBuilderViewModel()

    var body: some View {
        NavigationStack(path: $path) {

            SearchFieldView(text: $routeBuilderViewModel.searchText)
                .padding(.horizontal, 20)
                .padding(.bottom, 5)

        }
    }
}
