//
//  SignInViewController.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/08.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.whenLoginSuccess),
            name: Notification.Name("LoginSuccess"),
            object: nil)
                                               
    }
    
    @objc func whenLoginSuccess() {
        
        guard let nextViewController = self.storyboard?
            .instantiateViewController(withIdentifier: "UserDataCheckViewController")
        else {return}
        
        self.navigationController?
            .pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func touchUpSignInButton(_ sender: Any) {
        if (emailTextField.text == "") ||
            (passwordTextField.text == "") {
            //MARK:- show alert controller later
            return
        }
        
        SignService.signInPOSTRequest(
            email: emailTextField.text,
            password: passwordTextField.text,
            VC: self)
    }

    
    
}
