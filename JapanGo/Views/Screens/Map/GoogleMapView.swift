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

    func makeUIView(context: Context) -> GMSMapView {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: 36.5, longitude: 138.0, zoom: 5)
        let mapView = GMSMapView(options: options)
        let southWest = CLLocationCoordinate2D(latitude: 30.0, longitude: 128.0)
        let northEast = CLLocationCoordinate2D(latitude: 46.0, longitude: 146.0)
        mapView.cameraTargetBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        mapView.setMinZoom(6.0, maxZoom: 18)

//        let markerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
//        markerView.backgroundColor = .white
//        markerView.layer.cornerRadius = 12

//        let label = UILabel(frame: markerView.bounds)
//        label.text = "Tokyo"
//        label.textAlignment = .center
//        markerView.addSubview(label)

//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917)
//        marker.iconView = markerView
//        marker.map = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.clear()
        for place in places {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            marker.iconView = MarkerIconView(place: place)
            marker.map = uiView
        }
    }
}

#Preview {
    GoogleMapView(places: Place.mockArray)
}
