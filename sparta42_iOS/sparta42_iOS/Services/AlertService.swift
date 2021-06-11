//
//  AlertService.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/11.
//

import Foundation
import UIKit

class AlertService {
    private init() {}
    
    
    // ok 버튼 달랑 하나만 있는 alert를 보여줍니다.
    static func justAlert(VC: UIViewController, title: String, message: String?, preferredStyle: UIAlertController.Style) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okAction)
        
        VC.present(alert, animated: true, completion: nil)
    }
}
