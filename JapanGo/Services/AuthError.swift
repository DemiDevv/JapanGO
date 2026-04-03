//
//  AuthError.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 03.04.2026.
//

import Foundation

enum AuthError: Error {
    case missingClientID
    case missingRootViewController
    case missingToken
    case missingNonce
}
