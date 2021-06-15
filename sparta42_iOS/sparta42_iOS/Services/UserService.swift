//
//  UserHTTPService.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/11.
//

import Foundation
import UIKit


class UserService {
    static let shared = UserService()
    
    func setUserDefaults() {
        guard let url = URL.urlForUserMeGETRequest()
        else { fatalError("can't get url for GET /user/me ") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        else { return }
        // 이 부분에 accessToken 가져오기 실패 시 refreshToken 가져오게 하면 좋을 듯.
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            guard let response = response as? HTTPURLResponse
            else { return } // 에러처리하기.
            
            if 200...399 ~= response.statusCode {
                if let data = data,
                   let userMe: UserMe = try? JSONDecoder().decode(UserMe.self, from: data) {
                    
                    if let name = userMe.name {
                        UserDefaults.standard.setValue("\(name)", forKey: "userName")
                    }
                    if let email = userMe.email {
                        UserDefaults.standard.setValue("\(email)", forKey: "userEmail")
                    }
                    
                }
            }
            else {
                print("response code >= 400")
            }
        }
        task.resume()
        
    }
    
    func userMeGetRequest() -> UserMe {
        
        var result = UserMe.init()
        
        guard let url = URL.urlForUserMeGETRequest()
        else {return UserMe.empty}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
