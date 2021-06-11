//
//  SingletonService.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/11.
//

import Foundation

class SingletonService {
    static let shared = SingletonService()
    
    var accessToken: String?
    var tokenType: String?
}
