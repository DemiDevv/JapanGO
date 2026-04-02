//
//  GoogleAuthService.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 02.04.2026.
//

import FirebaseAuth
import GoogleSignIn
import Firebase
import UIKit

enum AuthError: Error {
    case missingClientID
    case missingRootViewController
    case missingToken
}

@MainActor
final class GoogleAuthService {

    func signIn() async throws -> User {

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.missingClientID
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            throw AuthError.missingRootViewController
        }

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.missingToken
        }

        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )

        let authResult = try await Auth.auth().signIn(with: credential)
        return authResult.user
    }

    func logout() {
        try? Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
    }
}
