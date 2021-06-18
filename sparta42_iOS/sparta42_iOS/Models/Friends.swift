//
//  Friends.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/17.
//

import Foundation

struct Friends: Codable {
    var friend: [Friend]
}

struct Friend: Codable {
    var latitude: Double
    var longtitude: Double
    var imageUrl: String
}
