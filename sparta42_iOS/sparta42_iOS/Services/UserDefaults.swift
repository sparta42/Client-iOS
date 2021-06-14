//
//  UserDefaults.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/11.
//

import Foundation

class UserDefaults {
    static let shared = UserDefaults()
    
    var accessToken: String?
    var tokenType: String?
}
