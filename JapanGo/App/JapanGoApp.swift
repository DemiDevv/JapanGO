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

@main
struct JapanGoApp: App {

    init() {
        FirebaseApp.configure()
        StringArrayTransformer.register()

        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let apiKey = dict["GOOGLE_MAPS_API_KEY"] as? String {
            GMSServices.provideAPIKey(apiKey)
        }

        UIWindow.appearance().backgroundColor = .blackJG
    }

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
        }
    }
}
