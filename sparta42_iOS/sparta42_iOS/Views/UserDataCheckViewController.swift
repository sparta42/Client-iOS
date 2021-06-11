//
//  UserDataCheckViewController.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/11.
//

import UIKit
import RxSwift
import RxCocoa

class UserDataCheckViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfoAndShowData()
    }
    
    private func getUserInfoAndShowData() {
        guard let url = URL.urlForUserMeGETRequest()
        else { return }
        let resource = Resource<UserMe>(url: url)
        let userMe = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .retry(3)
            .catchError { error in
                print(error.localizedDescription)
                return Observable.just(UserMe.empty)
            }.asDriver(onErrorJustReturn: UserMe.empty)
        
        userMe.map { userData in
            guard let name = userData.name
            else { return "name 얻기 실패" }
            return name
        }
        .drive(self.nameLabel.rx.text)
        .disposed(by: disposeBag)
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
