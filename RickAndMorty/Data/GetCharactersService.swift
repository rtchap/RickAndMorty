//
//  GetCharactersService.swift
//  RickAndMorty
//
//  Created by Ross Chapman on 9/29/20.
//  Copyright © 2020 Ross Chapman. All rights reserved.
//

import Foundation

class GetCharactersService {
    struct Config {
        let pageInfo: PageInfo
    }
    
    struct PageInfo: Decodable {
        init() {
            self.next = "https://rickandmortyapi.com/api/character/"
        }
        
        let count: Int = 0
        let pages: Int = 0
        var next: String? = nil
        let prev: String? = nil
    }
    
    struct Response: Decodable {
        let info: PageInfo
        let results: [Character]
    }
    
    enum Error: Swift.Error {
        case noNextPage
        case unknown
        case known(Swift.Error)
    }
    
    func get(config: Config, response: @escaping (Result<Response, Error>) -> Void) {
        guard
            let next = config.pageInfo.next,
            !next.isEmpty
            else
        {
            response(.failure(.noNextPage))
            
            return
        }
        
        guard let url = URL(string: next) else {
            response(.failure(.unknown))
            
            return
        }
        
        URLSession(configuration: .default).dataTask(with: url) { (data, httpResponse, error) in
            guard let data = data else {
                response(.failure(.unknown))
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let json = try decoder.decode(Response.self, from: data)
                response(.success(json))
                
                return
            } catch {
                print(error)
                
                response(.failure(.known(error)))
                
                return
            }
        }.resume()
    }
}
