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
    var id: Int
    var latitude: Double
    var longitude: Double
    var imageUrl: String?
    var title: String?
    var subtitle: String?
}


struct FriendsList: Codable {
    var friends: [Friend]
}
