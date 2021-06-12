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
        
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                
                var request = URLRequest(url: url)
                guard let tokenType = SingletonService.shared.tokenType,
                      let accessToken = SingletonService.shared.accessToken
                else { fatalError("there is no accessToken") }
                request.setValue(
                    "\(tokenType) \(accessToken)",
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
