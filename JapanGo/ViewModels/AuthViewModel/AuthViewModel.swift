//
//  AuthViewModel.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 02.04.2026.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    private let googleAuthService = GoogleAuthService()

    @Published var isLoggedIn: Bool = false
    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var photoURL: URL?

    init() {
        if let user = Auth.auth().currentUser {
            setUser(user: user)
        }
    }

    func signIn() async {
        do {
            let user = try await googleAuthService.signIn()
            setUser(user: user)
        } catch {
            print(error)
        }
    }

    private func setUser(user: User) {
        self.isLoggedIn = true
        self.userName = user.displayName ?? ""
        self.email = user.email ?? ""
        self.photoURL = user.photoURL
    }

    func logout() {
        googleAuthService.logout()
        isLoggedIn = false
        userName = ""
        email = ""
        photoURL = nil
    }
}
