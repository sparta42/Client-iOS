//
//  URL+Extensions.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/11.
//

import Foundation

extension URL {
    
    static func urlForSignUpPOSTRequest() -> URL? {
        return URL(string: "http://3.35.151.102:8080/auth/signup")
    }
    
    static func urlForSignInPOSTRequest() -> URL? {
        return URL(string: "http://3.35.151.102:8080/auth/login")
    }
    
    static func urlForUserMeGETRequest() -> URL? {
        return URL(string: "http://3.35.151.102:8080/user/me")
    }
}
