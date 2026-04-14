//
//  MarkerIconView.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 14.04.2026.
//

import SwiftUI
import UIKit
import Kingfisher

final class MarkerIconView: UIView {
    private let imageView = UIImageView()
    private let placeImageView = UIImageView()
    private var place: Place

    init(place: Place) {
        self.place = place
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        placeImageView.kf.setImage(with: URL(string: place.imageURLs[0]))
        placeImageView.contentMode = .scaleAspectFill
        placeImageView.layer.cornerRadius = 10
        placeImageView.clipsToBounds = true


        imageView.image = UIImage(named: "MarkerImage")
        imageView.contentMode = .scaleAspectFit
    }

    private func setupUI() {
        configure()
        addSubview(placeImageView)
        addSubview(imageView)
        setupConstraints()
        layoutIfNeeded()
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        placeImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            placeImageView.widthAnchor.constraint(equalToConstant: 25),
            placeImageView.heightAnchor.constraint(equalToConstant: 25),
            placeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5),
            placeImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
}

// MARK: - Preview

struct MarkerIconViewPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> MarkerIconView {
        MarkerIconView(place: Place.mock)
    }

    func updateUIView(_ uiView: MarkerIconView, context: Context) {}
}

#Preview {
    MarkerIconViewPreview()
        .frame(width: 50, height: 60)
}
