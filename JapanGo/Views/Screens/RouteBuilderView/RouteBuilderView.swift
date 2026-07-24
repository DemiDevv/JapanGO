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
    @Environment(\.dismiss) private var dismiss

    var onRouteBuilt: ((String) -> Void)?

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.blackJG.ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                    searchSection

                    if !routeBuilderViewModel.searchResults.isEmpty {
                        searchResultsList
                    } else {
                        selectedStopsList
                        Spacer()
                        bottomSection
                    }
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.creamJG)
                    .padding(10)
                    .background(Circle().fill(Color.blackGrayJG))
            }

            Spacer()

            Text("Route Builder")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.whiteJG)

            Spacer()

            Color.clear
                .frame(width: 36, height: 36)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    // MARK: - Search

    private var searchSection: some View {
        SearchFieldView(text: $routeBuilderViewModel.searchText)
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
    }

    // MARK: - Search Results

    private var searchResultsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(routeBuilderViewModel.searchResults) { suggestion in
                    Button {
                        routeBuilderViewModel.addStop(from: suggestion)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.redJG)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(suggestion.name)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.whiteJG)
                                    .lineLimit(1)

                                if !suggestion.address.isEmpty {
                                    Text(suggestion.address)
                                        .font(.system(size: 13))
                                        .foregroundStyle(.grayJG)
                                        .lineLimit(1)
                                }
                            }

                            Spacer()

                            Image(systemName: "plus.circle")
                                .font(.system(size: 20))
                                .foregroundStyle(.creamJG)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }

                    Divider()
                        .background(Color.blackGrayJG)
                        .padding(.leading, 56)
                }
            }
        }
    }

    // MARK: - Selected Stops

    private var selectedStopsList: some View {
        Group {
            if routeBuilderViewModel.selectedStops.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(routeBuilderViewModel.selectedStops.enumerated()), id: \.element.id) { index, stop in
                            stopRow(stop: stop, index: index)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
            }
        }
    }

    private func stopRow(stop: RouteStop, index: Int) -> some View {
        HStack(spacing: 12) {
            Text("\(index + 1)")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.blackJG)
                .frame(width: 28, height: 28)
                .background(Circle().fill(Color.creamJG))

            VStack(alignment: .leading, spacing: 2) {
                Text(stop.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.whiteJG)
                    .lineLimit(1)

                if !stop.address.isEmpty {
                    Text(stop.address)
                        .font(.system(size: 13))
                        .foregroundStyle(.grayJG)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    routeBuilderViewModel.removeStop(stop)
                }
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundStyle(.redJG)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blackGrayJG)
        )
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(systemName: "map")
                .font(.system(size: 40))
                .foregroundStyle(.grayJG)

            Text("Search and add places\nto build your route")
                .font(.system(size: 16))
                .foregroundStyle(.grayJG)
                .multilineTextAlignment(.center)

            Spacer()
        }
    }

    // MARK: - Bottom Section

    private var bottomSection: some View {
        VStack(spacing: 16) {
            if !routeBuilderViewModel.selectedStops.isEmpty {
                travelModePicker
            }

            buildRouteButton
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    private var travelModePicker: some View {
        HStack(spacing: 0) {
            ForEach(TravelMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        routeBuilderViewModel.travelMode = mode
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: mode.icon)
                            .font(.system(size: 14))
                        Text(mode.title)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(routeBuilderViewModel.travelMode == mode ? .blackJG : .creamJG)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(routeBuilderViewModel.travelMode == mode ? Color.creamJG : Color.clear)
                    )
                }
            }
        }
        .padding(4)
        .background(Capsule().fill(Color.blackGrayJG))
    }

    private var buildRouteButton: some View {
        Button {
            routeBuilderViewModel.buildRoute()
        } label: {
            HStack(spacing: 8) {
                if routeBuilderViewModel.isBuildingRoute {
                    ProgressView()
                        .tint(.whiteJG)
                }
                Text(routeBuilderViewModel.isBuildingRoute ? "Building..." : "Build Route")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.whiteJG)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(
                        routeBuilderViewModel.canBuildRoute
                        ? LinearGradient(colors: [.redJG, .blackGrayJG, .redJG],
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing)
                        : LinearGradient(colors: [.blackGrayJG, .blackGrayJG],
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing)
                    )
            )
        }
        .disabled(!routeBuilderViewModel.canBuildRoute || routeBuilderViewModel.isBuildingRoute)
        .onChange(of: routeBuilderViewModel.routePolyline) { _, polyline in
            guard let polyline else { return }
            onRouteBuilt?(polyline)
            dismiss()
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    @Previewable @StateObject var exploreViewModel = ExploreViewModel(service: LocalPlaceService())
    RouteBuilderView(path: $path)
        .environmentObject(exploreViewModel)
}
