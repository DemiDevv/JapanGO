//
//  LoginView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 02.04.2026.
//

import SwiftUI
import GoogleSignInSwift

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

                VStack {
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
                                .font(.system(size: 16, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .foregroundColor(.black.opacity(0.54))
                        .cornerRadius(12)
                    }
                }
                .padding(24)
                .background(Color.black.opacity(0.3))
                .cornerRadius(20)
            }
            .foregroundStyle(.whiteJG)


        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
