//
//  UserModels.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/08.
//

import Foundation

struct UserMe: Codable {
    var email: String?
    var id: Int?
    var imageUrl: String?
    var name: String?
    var provider: String?
    var providerId: String?
}

extension UserMe {
    static var empty: UserMe {
        return UserMe(email: "", id: 0, imageUrl: "", name: "", provider: "", providerId: "")
    }
}

