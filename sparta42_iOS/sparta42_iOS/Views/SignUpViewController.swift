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
            AlertService.justAlert(VC: self, title: "모든 필드를 입력하세요", message: nil, preferredStyle: UIAlertController.Style.alert)
            return
        }
        
        SignService.signUpPOSTRequest(
                name: usernameTextField.text,
                email: emailTextField.text,
                password: passwordTextField.text,
                VC: self)
    }
    

}
