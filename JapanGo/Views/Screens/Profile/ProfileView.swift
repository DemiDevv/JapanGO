//
//  ProfileView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 31.03.2026.
//

import SwiftUI
import Kingfisher

// MARK: - ProfileView

struct ProfileView: View {

    @State private var showLogoutAlert: Bool = false
    @Binding var path: NavigationPath
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {

        NavigationStack(path: $path) {
            VStack {
                Text("Profile")
                    .font(.largeTitle)
                    .foregroundStyle(.whiteJG)

                List {
                    avatarSection
                    statisticsSection
                    achievementsSection
                    settingsSection
                    toolsSection
                    aboutSection
                    logOutSection
                }
                .padding(.bottom, 70)
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.large)
            }
            .background(.blackJG)
        }
    }
}

// MARK: - Sections

private extension ProfileView {

    // MARK: Avatar

    var avatarSection: some View {
        Section {
            HStack(spacing: 14) {
                KFImage(authViewModel.photoURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(authViewModel.userName)
                        .font(.system(size: 16, weight: .medium))

                    Text(authViewModel.email)
                        .font(.system(size: 13))
                }
                .foregroundStyle(.whiteJG)
            }
            .padding(.vertical, 4)
        }
        .listRowBackground(Color.blackGrayJG)
    }

    // MARK: Statistics (disabled)

    var statisticsSection: some View {
        Section {
            HStack {
                statisticItem(value: "0", title: "Saved places")
                Divider()
                statisticItem(value: "0 / 47", title: "Prefectures")
                Divider()
                statisticItem(value: "0", title: "Visited")
            }
            .padding(.vertical, 8)
        } header: {
            comingSoonHeader("Statistics")
        }
        .opacity(0.45)
        .listRowBackground(Color.blackGrayJG)
    }

    // MARK: Achievements (disabled)

    var achievementsSection: some View {
        Section {
            HStack {
                achievementItem(icon: "star", title: "First visit")
                achievementItem(icon: "checkmark.circle", title: "5 temples")
                achievementItem(icon: "bell", title: "Explorer")
                achievementItem(icon: "heart", title: "10 favorites")
            }
            .padding(.vertical, 8)
        } header: {
            comingSoonHeader("Achievements")
        }
        .opacity(0.45)
        .listRowBackground(Color.blackGrayJG)
    }

    // MARK: Settings

    var settingsSection: some View {
        Section {
            NavigationLink {
                // TODO: - LanguageSettingsView()
            } label: {
                profileRow(icon: "globe", iconColor: .blue, title: "Language", detail: "English")
            }

            NavigationLink {
                // TODO: - AppearanceSettingsView()
            } label: {
                profileRow(icon: "paintbrush", iconColor: .purple, title: "Appearance", detail: "System")
            }
        } header: {
            Text("Settings")
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .semibold))
        }
        .listRowBackground(Color.blackGrayJG)
    }

    // MARK: Tools

    var toolsSection: some View {
        Section {
            NavigationLink {
                Text("Currency Converter") // TODO: - CurrencyConverterView
            } label: {
                profileRow(icon: "yensign", iconColor: .orange, title: "Currency converter")
            }
        } header: {
            Text("Tools")
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .semibold))
        }
        .listRowBackground(Color.blackGrayJG)
    }

    // MARK: About

    var aboutSection: some View {
        Section {
            NavigationLink {
                Text("About App") // TODO: - AboutAppView
            } label: {
                profileRow(icon: "info.circle", iconColor: .gray, title: "About app")
            }
        }
        header: {
              Text("About")
                  .foregroundStyle(.white)
                  .font(.system(size: 14, weight: .semibold))
          }
        .listRowBackground(Color.blackGrayJG)
    }

    // MARK: Log Out

    var logOutSection: some View {
        Section {
            Button(role: .destructive) {
                // TODO: - Log out action
                showLogoutAlert = true
            } label: {
                Text("Выйти")
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: .infinity)
            }
            .alert("Выйти из JapanGO", isPresented: $showLogoutAlert) {
                Button("Отмена", role: .cancel) {}
                Button("Да", role: .destructive) {
                    authViewModel.logout()
                }
            } message: {
                Text("Вы точно хотите выйти?")
            }
        }
        .listRowBackground(Color.blackGrayJG)
    }
}

// MARK: - Components

private extension ProfileView {

    func profileRow(
        icon: String,
        iconColor: Color,
        title: String,
        detail: String? = nil
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .frame(width: 24)

            Text(title)
                .foregroundStyle(.whiteJG)

            if let detail {
                Spacer()
                Text(detail)
                    .foregroundStyle(.secondary)
                    .font(.system(size: 14))
            }
        }
    }

    func statisticItem(value: String, title: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .foregroundStyle(.white)
                .font(.system(size: 20, weight: .medium))

            Text(title)
                .font(.system(size: 11))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
    }

    func achievementItem(icon: String, title: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.creamJG)
                .frame(width: 44, height: 44)
                .background(Color.blackJG)
                .clipShape(Circle())

            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 10))
        }
        .frame(maxWidth: .infinity)
    }

    func comingSoonHeader(_ title: String) -> some View {
        HStack(spacing: 6) {
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .semibold))

            Text("Coming soon")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.orange)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.orange.opacity(0.15))
                .clipShape(Capsule())
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var profilePath = NavigationPath()
    NavigationStack {
        ProfileView(path: $profilePath)
            .environmentObject(AuthViewModel())
    }
}
