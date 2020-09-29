//
//  GetCharactersServiceTests.swift
//  RickAndMortyTests
//
//  Created by Ross Chapman on 9/29/20.
//  Copyright © 2020 Ross Chapman. All rights reserved.
//

import XCTest
@testable import RickAndMorty

class GetCharactersServiceTests: XCTestCase {
    
}

// MARK: - get

extension GetCharactersServiceTests {
    func test_get() {
        let service = GetCharactersService()
        
        let expectation = self.expectation(description: "test")
        
        service.get { result in
            expectation.fulfill()
            
            if case .success = result {
                XCTAssertTrue(true)
            } else {
                XCTAssertFalse(true)
            }
        }
        
        self.waitForExpectations(timeout: 1)
    }
}
