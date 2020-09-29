//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Ross Chapman on 9/29/20.
//  Copyright © 2020 Ross Chapman. All rights reserved.
//

import Foundation

class CharactersViewModel {
    private(set) var characters: [CharacterViewModel] = []
    private(set) var characterCount: Int = 0
    private var pageInfo = GetCharactersService.PageInfo()
    private var isFetchingNext: Bool = false
    
    var updateViews: (() -> Void)?
    
    func getCharacters() {
        guard !self.isFetchingNext else { return }
        guard self.pageInfo.next != nil else { return }
        
        self.isFetchingNext = true
        
        let service = GetCharactersService()
        service.get(config: .init(pageInfo: self.pageInfo)) { [weak self] (result) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                defer { self.isFetchingNext = false }
                
                switch result {
                case let .success(response):
                    let viewModels = response.results.map(CharacterViewModel.init)
                    self.characters.append(contentsOf: viewModels)
                    self.characterCount = self.characters.count
                    self.pageInfo = response.info
                case .failure:
                    return
                }
                
                self.updateViews?()
            }
        }
    }
}
