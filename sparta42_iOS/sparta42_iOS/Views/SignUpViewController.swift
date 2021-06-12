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
            AlertService.justAlert(VC: self, title: "모든 필드를 입력하세요", message: nil, preferredStyle: .alert)
            return
        }
        
        // post 요청과 동시에 에러 처리
        SignService.signUpPOSTRequest(
            name: usernameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text) { result in
            
            if (result == false) {
                DispatchQueue.main.async {
                    AlertService.justAlert(
                        VC: self,
                        title: "오류",
                        message: "이메일이 올바른 형식이 아니거나, 이미 가입한 이메일입니다.",
                        preferredStyle: .alert)
                }
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        
    }
    

}
