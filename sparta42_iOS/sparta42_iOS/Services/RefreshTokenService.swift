//
//  RefreshTokenService.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/14.
//

import Foundation


// access 토큰 있나 체크하고
class RefreshTokenService {

    
    static func checkAccessTokenAvailable(completion: @escaping (CommunicationResult) -> Void) {
        guard let url = URL.urlForUserMeGETRequest()
        else { fatalError("Can't get URL for User/Me") }
        
        var request = URLRequest(url: url)
        
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        else {
            completion(CommunicationResult.FAILURE)
            return
        }

        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if (200...399 ~= response.statusCode) == false {
                    updateTokens { result in
                        if result == false {
                            // 성공 시 아무것도 안 함.
                            completion (CommunicationResult.SUCCESS)
                        } else {
                            // 실패 시 로그인 화면으로 돌아가야 함.
                            completion (CommunicationResult.FAILURE)
                        }
                    }
                }
                else {
                    completion(CommunicationResult.SUCCESS)
                }
            }
            else {
                completion(CommunicationResult.FAILURE)
            }
        }
        task.resume()
    }
    
    static func updateTokens(completion: @escaping (Bool) -> Void) {
        guard let url = URL.urlForRefreshTokenPOSTRequest()
        else { fatalError("can't get url for refresh token") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        else {
            completion(false)
            return
        }
        
        request.setValue("Bearer \(refreshToken)",
                         forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.uploadTask(with: request, from: Data()) { data, response, error in
            
            guard let response = response as? HTTPURLResponse
            else { fatalError("can't get response from updateTokens post request") }
            
            if 200...399 ~= response.statusCode {
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    guard let refreshTokenResponse =
                            json["refreshToken"] as? String,
                          let accessTokenResponse =
                            json["accessToken"] as? String
                    else {
                        completion(false)
                        return
                    }
                    
                    UserDefaults.standard.set("\(accessTokenResponse)", forKey: "accessToken")
                    UserDefaults.standard.set("\(refreshTokenResponse)", forKey: "refreshToken")
                }
                completion(true)
            } else {
                completion(false)
            }
        }
        task.resume()
        
        
    }
    
}
