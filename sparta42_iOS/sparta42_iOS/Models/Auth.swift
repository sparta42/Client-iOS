//
//  Auth.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/08.
//

import Foundation

struct AuthSignIn: Codable {
    var email: String?
    var password: String?
}

struct AuthRefreshtoken: Codable {
    var refreshToken: String?
}

struct AuthSignup: Codable {
    var email: String?
    var name: String?
    var password: String?
}
