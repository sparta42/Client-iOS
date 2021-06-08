//
//  SignInViewController.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/08.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    @IBAction func touchUpSignInButton(_ sender: Any) {
        if (emailTextField.text == "") ||
            (passwordTextField.text == "") {
            //MARK:- show alert controller later
            return
        }
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else {return}
    
        signUpPOSTRequest(email: email,
                          password: password)
        
    }
    private func signUpPOSTRequest(email: String, password: String) {
        
        let authSignIn = AuthSignIn(email: email, password: password)
        guard let signInData = try? JSONEncoder().encode(authSignIn)
        else { return }
        
        guard let url = URL(string: "http://3.35.151.102:8080/auth/login")
        else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: signInData) {
            (data, response, error) in
            
            if let e = error {
                NSLog("SignIn POST 과정에서 에러 발생: \(e)")
                return
            }
            
            // status code 파싱
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {return}
  
            
            guard let responseString = String(data: data!, encoding: .utf8)
            else {return}
                        
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] {
                guard let tokenType = json["tokenType"] as? String,
                      let accessToken = json["accessToken"] as? String
                else { return }
                
                
                self.userMeGetRequest(tokenType: tokenType, accessToken: accessToken)
            }
            
        }
        task.resume()
    }
    
    
    private func userMeGetRequest(tokenType: String, accessToken: String) {
        guard let url = URL(string: "http://3.35.151.102:8080/user/me")
        else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if let e = error {
                NSLog("SignIn POST 과정에서 에러 발생: \(e)")
                return
            }
            
            if let data = data {
                if let userMe = try? JSONDecoder().decode(UserMe.self, from: data) {
                    DispatchQueue.main.async {
                        self.userNameLabel?.text
                            = "\(userMe.name ?? "이름을 받아올 수 없습니다.")"
                    }
                }
                
            }
            
            
        }
        task.resume()
    }

    
    
}
