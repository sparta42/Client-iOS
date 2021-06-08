//
//  AuthResponse.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/09.
//

import Foundation
import UIKit

struct SignInResponse: Codable {
    var tokenType: String?
    var accessToken: String?
    var refreshToken: String?
}
