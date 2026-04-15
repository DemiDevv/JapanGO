//
//  GoogleMapView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 05.04.2026.
//

import SwiftUI
import GoogleMaps
import Combine

struct GoogleMapView: UIViewRepresentable {

    let places: [Place]
    @Binding var selectedPlace: Place?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: 36.5, longitude: 138.0, zoom: 5)
        let mapView = GMSMapView(options: options)
        let southWest = CLLocationCoordinate2D(latitude: 30.0, longitude: 128.0)
        let northEast = CLLocationCoordinate2D(latitude: 46.0, longitude: 146.0)
        mapView.cameraTargetBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        mapView.setMinZoom(6.0, maxZoom: 18)
        mapView.delegate = context.coordinator

        if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json"),
           let style = try? GMSMapStyle(contentsOfFileURL: styleURL) {
            mapView.mapStyle = style
        }

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.clear()
        for place in places {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            marker.iconView = MarkerIconView(place: place)
            marker.userData = place
            marker.map = uiView
        }
    }

    //MARK: - Coordinator
    final class Coordinator: NSObject, GMSMapViewDelegate {
        private let parent: GoogleMapView

        init(parent: GoogleMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            guard let place = marker.userData as? Place else { return false }
            parent.selectedPlace = place
            return true
        }
    }
}
