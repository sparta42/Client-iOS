//
//  URLRequest+Extension.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/11.
//

import Foundation
import RxSwift
import RxCocoa


struct Resource<T> {
    let url: URL

}

extension URLRequest {
 
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        
        RefreshTokenService.checkAccessTokenAvailable { result in
            if result == CommunicationResult.FAILURE {
                // somecode to go back to login VC
                print("can't get refreshToken. Going back to Login ViewController")
            }
        }
        
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                
                var request = URLRequest(url: url)
                
                guard let accessToken = UserDefaults.standard.string(forKey: "accessToken")
                else { fatalError("There's no accessToken in UserDefaults") }

                request.setValue(
                    "Bearer \(accessToken)",
                    forHTTPHeaderField: "Authorization")
                
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in
                
                if 200...399 ~= response.statusCode {
                    return try JSONDecoder().decode(T.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }.asObservable()
    }
    
}
