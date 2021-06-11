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
    static func signUpPOSTRequest(name: String?, email: String?, password: String?, VC: UIViewController) {
        
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
            if 200..<300 ~= response.statusCode {
                print("signUp POST success")
            } else {
                DispatchQueue.main.async {
                    AlertService.justAlert(
                        VC: VC,
                        title: "오류",
                        message: "이메일이 올바른 형식이 아니거나, 이미 가입한 이메일입니다.",
                        preferredStyle: .alert)
                }
            }
            if let e = error {
                NSLog("SignUp POST 과정에서 에러 발생: \(e)")
            }
        }
        task.resume()
        
        
    }
    
    static func signInPOSTRequest(email: String?, password: String?, VC: UIViewController) {
        
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
        
            if 200..<300 ~= httpResponse.statusCode {
                print("signUp POST success")
            } else {
                DispatchQueue.main.async {
                    AlertService.justAlert(
                        VC: VC,
                        title: "오류",
                        message: "가입되어 있지 않은 아이디 또는 잘못된 비밀번호입니다.",
                        preferredStyle: .alert)
                }
                return
            }
            
            if let e = error {
                NSLog("SignIn POST 과정에서 에러 발생: \(e)")
                return
            }
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                guard let tokenType = json["tokenType"] as? String,
                      let accessToken = json["accessToken"] as? String
                else { return }

                SingletonService.shared.accessToken = accessToken
                SingletonService.shared.tokenType = tokenType
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("LoginSuccess"), object: nil)
                }
                
            }
        }
        task.resume()
    }
    
    
    
}
