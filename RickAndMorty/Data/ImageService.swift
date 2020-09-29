//
//  ImageService.swift
//  RickAndMorty
//
//  Created by Ross Chapman on 9/29/20.
//  Copyright © 2020 Ross Chapman. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    struct Config {
        let url: String
    }
    
    func get(config: Config, response: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: config.url) else {
            response(nil)
            
            return
        }
        
        URLSession(configuration: .default).dataTask(with: url) { (data, httpResponse, error) in
            guard
                let data = data,
                let image = UIImage(data: data)
                else
            {
                response(nil)
                
                return
            }
            
            response(image)
            
        }.resume()
    }
}
