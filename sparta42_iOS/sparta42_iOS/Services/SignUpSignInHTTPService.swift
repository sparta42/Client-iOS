//
//  SignUpService.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/11.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

enum HTTPError: Error {
    case code400
    case code401
}

class SignService {
    static func signUpPOSTRequest(name: String?, email: String?, password: String?, completion: @escaping (Bool) -> Void) {
        
        let authSignUp = AuthSignUp(email: email, name: name, password: password)
        
        guard let signUpData = try? JSONEncoder().encode(authSignUp)
        else { return }
        
        guard let url = URL.urlForSignUpPOSTRequest()
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: signUpData) {
            (data, response, error) in
            
            guard let response = response as? HTTPURLResponse
            else {return}
            if 200...399 ~= response.statusCode {
                print("signUp POST success")
                return completion(true)
            } else {
                if let e = error {
                    print(e.localizedDescription)
                }
                return completion(false)
            }
            
        }
        task.resume()
        
        
    }
    
    static func signInPOSTRequest(email: String?, password: String?, completion: @escaping (Bool) -> Void) {
        
        let authSignIn = AuthSignIn(email: email, password: password)
        guard let signInData = try? JSONEncoder().encode(authSignIn)
        else { return }
        
        guard let url = URL.urlForSignInPOSTRequest()
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: signInData) {
            (data, response, error) in
            
            // status code 파싱
            guard let httpResponse = response as? HTTPURLResponse
            else {return}
        
            if 200...399 ~= httpResponse.statusCode {
                print("signUp POST success")
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    guard let tokenType = json["tokenType"] as? String,
                          let accessToken = json["accessToken"] as? String
                    else { return }

                    SingletonService.shared.accessToken = accessToken
                    SingletonService.shared.tokenType = tokenType
                    
                completion(true)
                
                } else {
                    return completion(false)
                }
            } else {
                completion(false)
            }
        }
        task.resume()
    }
    
    
    
}
