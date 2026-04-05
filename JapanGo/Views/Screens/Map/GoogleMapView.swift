//
//  GoogleMapView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 05.04.2026.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {

    func makeUIView(context: Context) -> GMSMapView {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: 36.5, longitude: 138.0, zoom: 5)
        let mapView = GMSMapView(options: options)
        let southWest = CLLocationCoordinate2D(latitude: 36.0, longitude: 136.0)
        let northEast = CLLocationCoordinate2D(latitude: 37.5, longitude: 139.0)
        mapView.cameraTargetBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        mapView.setMinZoom(5.0, maxZoom: 18)

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {

    }
}

#Preview {
    GoogleMapView()
}
