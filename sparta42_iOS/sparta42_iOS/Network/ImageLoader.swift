//
//  ImageLoader.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/21.
//
import UIKit

class ImageLoader {
    static func load64pxImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let url: URL = URL(string: url),
           let data = try? Data(contentsOf: url) {
            
            guard let rawImage = UIImage(data: data)
            else {
                print("can't resize image")
                return
            }
            let resizedImage = rawImage.resize(64, 64)
            completion(resizedImage)
        }
        else {
            print("url for loading image is invalid")
            completion(nil)
        }
        
        
    }
}
