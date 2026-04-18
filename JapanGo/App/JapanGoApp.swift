//
//  JapanGoApp.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 05.03.2026.
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleMaps
import GooglePlaces

@main
struct JapanGoApp: App {

    init() {
        FirebaseApp.configure()
        StringArrayTransformer.register()

        let apiKey = Configuration.googleMapsAPIKey
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)

        UIWindow.appearance().backgroundColor = .blackJG
    }

    @StateObject var exploreViewModel = ExploreViewModel(service: LocalPlaceService())
    @StateObject var favoriteViewModel = FavoriteViewModel(repository: CoreDataManager())
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if !authViewModel.isLoggedIn {
                    LoginView()
                } else {
                    RootView()
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .environmentObject(authViewModel)
            .environmentObject(favoriteViewModel)
            .environmentObject(exploreViewModel)
        }
    }
}
