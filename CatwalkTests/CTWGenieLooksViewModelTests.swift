//
//  CTWGenieLooksViewModelTests.swift
//  CatwalkTests
//
//  Created by CTWLK on 8/17/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import XCTest
@testable import Catwalk

class CTWGenieLooksViewModelTests: XCTestCase {

    func testCTWGenieLooksViewModel_WhenNoLooksAvailable_totalLooksShouldReturnZero() {
        let sut = CTWGenieLooksViewModel(looks: [])
        XCTAssertEqual(sut.totalLooks, 0)
    }
    
    func testCTWGenieLooksViewModel_WhenOneLookAvailable_totalLooksShouldReturnOne() {
        let sut = CTWGenieLooksViewModel(looks: [CTWLook()])
        XCTAssertEqual(sut.totalLooks, 1)
    }
    
    func testCTWGenieLooksViewModel_WhenNoLooksAvailable_looksCounterDescriptionShouldReturnEmptyString() {
        let sut = CTWGenieLooksViewModel(looks: [])
        XCTAssertEqual(sut.looksCounterDescription, "")
    }
    
    func testCTWGenieLooksViewModel_WhenOneLookAvailable_startLooksCounterDescriptionShouldReturnProperResponse() {
        let sut = CTWGenieLooksViewModel(looks: [CTWLook()])
        XCTAssertEqual(sut.looksCounterDescription, "Look 1 de 1")
    }
    
    func testCTWGenieLooksViewModel_WhenTwoLooksAvailable_startLooksCounterDescriptionShouldReturnProperResponse() {
        let sut = CTWGenieLooksViewModel(looks: [CTWLook(), CTWLook()])
        XCTAssertEqual(sut.looksCounterDescription, "Look 1 de 2")
    }
    
    func testCTWGenieLooksViewModel_WhenTwoLooksAvailableAndZeroAsCurrentIndex_looksCounterDescriptionShouldReturnProperResponse() {
        var sut = CTWGenieLooksViewModel(looks: [CTWLook(), CTWLook()])
        sut.currentLookIndex = 0
        XCTAssertEqual(sut.looksCounterDescription, "Look 1 de 2")
    }
    
    func testCTWGenieLooksViewModel_WhenTwoLooksAvailableAndOneAsCurrentIndex_looksCounterDescriptionShouldReturnProperResponse() {
        var sut = CTWGenieLooksViewModel(looks: [CTWLook(), CTWLook()])
        sut.currentLookIndex = 1
        XCTAssertEqual(sut.looksCounterDescription, "Look 2 de 2")
    }
    
    func testCTWGenieLooksViewModel_WhenTwoLooksAvailableAndZeroAsCurrentIndex_currentLookShouldReturnProperLook() {
        let firstLook = CTWLook(items: [CTWLookItem()])
        var sut = CTWGenieLooksViewModel(looks: [firstLook, CTWLook()])
        sut.currentLookIndex = 0
        XCTAssertEqual(sut.currentLook?.items.count, 1)
    }
    
    func testCTWGenieLooksViewModel_WhenTwoLooksAvailableAndOneAsCurrentIndex_currentLookShouldReturnProperLook() {
        let secondLook = CTWLook(items: [CTWLookItem()])
        var sut = CTWGenieLooksViewModel(looks: [CTWLook(), secondLook])
        sut.currentLookIndex = 1
        XCTAssertEqual(sut.currentLook?.items.count, 1)
    }
    
    func testCTWGenieLooksViewModel_WhenNoLookAvailable_currentLookTotalPriceShouldReturnProperResponse() {
        let sut = CTWGenieLooksViewModel(looks: [])
        XCTAssertEqual(sut.currentLookTotalPrice, "")
    }
    
    func testCTWGenieLooksViewModel_WhenCurrentLookHasSingleItem_currentLookTotalPriceShouldReturnProperResponse() {
        let firstItem = CTWLookItem(weight: nil, column: nil, product: CTWProduct(headline: nil, productId: nil, image: nil, price: CTWPrice(originalPriceInCents: 18500, currentPriceInCents: 14500), sizes: nil))
        let look = CTWLook(items: [firstItem])
        
        var sut = CTWGenieLooksViewModel(looks: [look])
        sut.currentLookIndex = 0
        XCTAssertEqual(sut.currentLookTotalPrice, "por R$ 145,00")
    }
    
    func testCTWGenieLooksViewModel_WhenCurrentLookHasMultipleItems_currentLookTotalPriceShouldReturnProperResponse() {
        let firstItem = CTWLookItem(weight: nil, column: nil, product: CTWProduct(headline: nil, productId: nil, image: nil, price: CTWPrice(originalPriceInCents: 18500, currentPriceInCents: 14500), sizes: nil))
        let secondItem = CTWLookItem(weight: nil, column: nil, product: CTWProduct(headline: nil, productId: nil, image: nil, price: CTWPrice(originalPriceInCents: 20000, currentPriceInCents: 19450), sizes: nil))
        let look = CTWLook(items: [firstItem, secondItem])
        
        var sut = CTWGenieLooksViewModel(looks: [look])
        sut.currentLookIndex = 0
        XCTAssertEqual(sut.currentLookTotalPrice, "por R$ 339,50")
    }

}
