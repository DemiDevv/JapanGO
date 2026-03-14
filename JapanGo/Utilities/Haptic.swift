//
//  Haptic.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 14.03.2026.
//

import Foundation
import UIKit

func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}
