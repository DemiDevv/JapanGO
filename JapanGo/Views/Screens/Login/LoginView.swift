//
//  LoginView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 02.04.2026.
//

import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct LoginView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Image("BackgroundJapanGO")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Text("JapanGO")
                    .font(.system(size: 50))

                Text("Explore Japan effortlessly")

                VStack(spacing: 12) {
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                        request.nonce = authViewModel.generateAppleNonce()
                    } onCompletion: { result in
                        Task {
                            await authViewModel.signInWithApple(result: result)
                        }
                    }
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 50)
                    .cornerRadius(12)

                    Button {
                        Task {
                            await authViewModel.signIn()
                        }
                    } label: {
                        HStack {
                            Image("GoogleLogo")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Sign in with Google")
                                .font(.system(size: 20, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                }
                .padding(24)
                .background(Color.black.opacity(0.3))
                .cornerRadius(20)
                .padding(20)
            }
            .foregroundStyle(.whiteJG)


        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
