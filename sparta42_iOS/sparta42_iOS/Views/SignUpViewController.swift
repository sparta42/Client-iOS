//
//  SignUpViewController.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/08.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func touchUpSignUpButton(_ sender: Any) {
        
        if (usernameTextField.text == "") ||
            (emailTextField.text == "") ||
            (passwordTextField.text == "") {
            //MARK:- show alert controller later
            return
        }
        guard let name = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text
        else {return}
    
        signUpPOSTRequest(name: name,
                          email: email,
                          password: password)
        
        
    }
    
    private func signUpPOSTRequest(name: String, email: String, password: String) {
        
        let authSignUp = AuthSignup(email: email, name: name, password: password)
        guard let signUpData = try? JSONEncoder().encode(authSignUp)
        else { return }
        
        guard let url = URL(string: "http://3.35.151.102:8080/auth/signup")
        else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: signUpData) {
            (data, response, error) in
            
            if let e = error {
                NSLog("SignUp POST 과정에서 에러 발생: \(e)")
            }
            
            print("signup post success")
            print("response: \(String(describing: response))")
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
}
