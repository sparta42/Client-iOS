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
        
        // post 요청과 동시에 에러 처리
        SignService.signInPOSTRequest(
            email: emailTextField.text,
            password: passwordTextField.text) { result in
            if (result == false) {
                DispatchQueue.main.async {
                    AlertService.justAlert(
                        VC: self,
                        title: "오류",
                        message: "이메일이 올바른 형식이 아니거나, 가입되지 않은 계정입니다.",
                        preferredStyle: .alert)
                }
            } else {
                print("signIn success")
                if let url = URL.urlForUserMeGETRequest() {
                    let resource = Resource<UserMe>(url: url)
                    URLRequest.load(resource: resource)
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            
                
                DispatchQueue.main.async {
                    
//                    guard let nextViewController = self.storyboard?
//                        .instantiateViewController(withIdentifier: "UserDataCheckViewController")
//                    else {return}
//
//                    self.navigationController?
//                        .pushViewController(nextViewController, animated: true)
                }
            }
        }
    }

    
    
}
