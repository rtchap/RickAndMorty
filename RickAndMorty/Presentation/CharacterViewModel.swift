//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by Ross Chapman on 9/29/20.
//  Copyright © 2020 Ross Chapman. All rights reserved.
//

import Foundation
import UIKit

class CharacterViewModel {
    init(character: Character) {
        self.character = character
    }
    
    private let character: Character
    
    var name: String { self.character.name }
    
    var title: String { self.character.name }
    var subTitle: String { """
        Status: \(self.character.status)
        Species: \(self.character.species)
        """ }
    var location: String { self.character.location.name }
    
    func requestImage(response: @escaping (UIImage, String) -> Void) {
        let service = ImageService()
        service.get(config: .init(url: self.character.image)) { [weak self] (image) in
            guard let self = self else { return }
            guard let image = image else { return }
            
            DispatchQueue.main.async {
                response(image, self.character.name)
            }
        }
    }
}
