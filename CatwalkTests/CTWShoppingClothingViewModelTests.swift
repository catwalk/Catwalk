//
//  CTWShoppingClothingViewModel.swift
//  CatwalkTests
//
//  Created by CTWLK on 8/17/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import XCTest
@testable import Catwalk

class CTWShoppingClothingViewModelTests: XCTestCase {
    
    func testCTWShoppingClothingViewModel_WhenItemHeadlineNotGiven_headlineShouldReturnNil() {
        let product = CTWProduct()
        let sut = CTWShoppingClothingViewModel(product: product, delegate: nil)
        XCTAssertNil(sut.headline)
    }

    func testCTWShoppingClothingViewModel_WhenItemHeadlineIsGiven_headlineShouldReturnProductHeadline() {
        let product = CTWProduct(headline: "Item name")
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.headline, "Item name")
    }
    
    func testCTWShoppingClothingViewModel_WhenItemPriceNotGiven_currentPriceShouldReturnNil() {
        let product = CTWProduct()
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertNil(sut.currentPrice)
    }
    
    func testCTWShoppingClothingViewModel_WhenItemPriceIsGiven_currentPriceShouldReturnFormattedProductPrice() {
        let product = CTWProduct(price: CTWPrice(originalPriceInCents: 15000, currentPriceInCents: 14250))
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.currentPrice, "R$ 142,50")
    }
    
    func testCTWShoppingClothingViewModel_WhenItemImageNotGiven_imageURLShouldReturnNil() {
        let product = CTWProduct()
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertNil(sut.imageURL)
    }
    
    func testCTWShoppingClothingViewModel_WhenItemImageIsGiven_imageURLShouldReturnImageURL() {
        let product = CTWProduct(image: "https://www.example.com")
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.imageURL, URL(string: "https://www.example.com"))
    }
    
    func testCTWShoppingClothingViewModel_WhenItemSizesNotGiven_sizesCountShouldReturnZero() {
        let product = CTWProduct()
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.sizesCount, 0)
    }
    
    func testCTWShoppingClothingViewModel_WhenZeroItemSizes_sizesCountShouldReturnZero() {
        let product = CTWProduct(sizes: [])
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.sizesCount, 0)
    }
    
    func testCTWShoppingClothingViewModel_WithOneItemSize_sizesCountShouldReturnOne() {
        let product = CTWProduct(sizes: [CTWSize()])
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.sizesCount, 1)
    }
    
    func testCTWShoppingClothingViewModel_WithTwoItemSizes_sizesCountShouldReturnTwo() {
        let product = CTWProduct(sizes: [CTWSize(), CTWSize()])
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.sizesCount, 2)
    }
    
    func testCTWShoppingClothingViewModel_WhenNoSizesGiven_sizeAtIndexShouldReturnEmptyString() {
        let product = CTWProduct()
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.sizeAt(index: 0), "")
    }
    
    func testCTWShoppingClothingViewModel_WhenEmptySizesListGiven_sizeAtIndexShouldReturnEmptyString() {
        let product = CTWProduct(sizes: [])
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.sizeAt(index: 0), "")
    }
    
    func testCTWShoppingClothingViewModel_WhenSizesListGiven_sizeAtIndexShouldReturnSizeAtIndexGiven() {
        let product = CTWProduct(sizes: [CTWSize(), CTWSize(identifier: "PP")])
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.sizeAt(index: 1), "PP")
    }
    
    func testCTWShoppingClothingViewModel_WhenNoSizesGiven_textForSizeAtIndexShouldReturnEmptyString() {
        let product = CTWProduct()
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.textForSizeAt(index: 0), "")
    }
    
    func testCTWShoppingClothingViewModel_WhenEmptySizesListGiven_textForSizeAtIndexShouldReturnEmptyString() {
        let product = CTWProduct(sizes: [])
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.textForSizeAt(index: 0), "")
    }
    
    func testCTWShoppingClothingViewModel_WhenSizesListGiven_textForSizeAtIndexShouldReturnFormattedTextSize() {
        let product = CTWProduct(sizes: [CTWSize(), CTWSize(identifier: "PP")])
        let sut = CTWShoppingClothingViewModel(product: product)
        XCTAssertEqual(sut.textForSizeAt(index: 1), "Tamanho PP")
    }

}
