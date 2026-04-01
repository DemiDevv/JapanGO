//
//  JapanGoApp.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 05.03.2026.
//

import SwiftUI

@main
struct JapanGoApp: App {

    init() {
        StringArrayTransformer.register()
    }

    @StateObject var favoriteViewModel = FavoriteViewModel(repository: CoreDataManager())
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(favoriteViewModel)
        }
    }
}
