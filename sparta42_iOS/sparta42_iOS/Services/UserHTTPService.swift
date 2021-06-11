//
//  UserHTTPService.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/11.
//

import Foundation
import UIKit


class UserService {
    static func userMeGetRequest() -> UserMe {
        
        var result = UserMe.init()
        
        guard let url = URL.urlForUserMeGETRequest()
        else {return UserMe.empty}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        guard let tokenType = SingletonService.shared.tokenType,
              let accessToken = SingletonService.shared.accessToken
        else {return UserMe.empty}
        
        request.setValue("\(tokenType) \(accessToken)",
                         forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if let data = data,
               let userMe = try? JSONDecoder().decode(UserMe.self, from: data) {
                result.email = userMe.email
                result.id = userMe.id
                result.imageUrl = userMe.imageUrl
                result.name = userMe.name
                result.provider = userMe.provider
                result.providerId = userMe.providerId
                print (userMe)
            }
            
            
        }
        task.resume()
        
        return result
    }
}
