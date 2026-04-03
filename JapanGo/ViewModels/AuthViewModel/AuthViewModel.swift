//
//  AuthViewModel.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 02.04.2026.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    private let googleAuthService = GoogleAuthService()
    private let appleAuthService = AppleAuthService()

    @Published var isLoggedIn: Bool = false
    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var photoURL: URL?

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    init() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                if let user {
                    self?.setUser(user: user)
                } else {
                    self?.clearUser()
                }
            }
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

    func generateAppleNonce() -> String {
        appleAuthService.generateNonce()
    }

    func signInWithApple(result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let authorization):
            do {
                let user = try await appleAuthService.signIn(with: authorization)
                setUser(user: user)
            } catch {
                print(error)
            }
        case .failure(let error):
            print(error)
        }
    }

    private func setUser(user: User) {
        isLoggedIn = true
        userName = user.displayName ?? ""
        email = user.email ?? ""
        photoURL = user.photoURL
    }

    private func clearUser() {
        isLoggedIn = false
        userName = ""
        email = ""
        photoURL = nil
    }

    func logout() {
        googleAuthService.logout()
    }
}
