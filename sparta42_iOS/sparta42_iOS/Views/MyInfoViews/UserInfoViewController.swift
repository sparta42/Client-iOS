//
//  UserInfoViewController.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/15.
//

import UIKit
import RxSwift

class UserInfoViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.rx.observe(String.self, "userName")
            .subscribe(onNext: { userName in
                if let userName = userName {
                    DispatchQueue.main.async {
                        self.userNameLabel.text = userName
                    }
                }
                
            }).disposed(by: disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
