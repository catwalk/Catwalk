//
//  CTWClothing.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

struct CTWProduct: Decodable {
    var headline: String?
    var productId: String?
    var image: String?
    var sku: String?
    var price: CTWPrice?
    var sizes: [CTWSize]?
    var chosenSKU: String?
}

struct CTWShoppingProduct {
    var productId: String?
    var sku: String?
    var identifier: String?
}

struct CTWPrice: Decodable {
    var originalPriceInCents: Float?
    var currentPriceInCents: Float?
}

struct CTWSize: Decodable {
    var identifier: String?
    var available: Bool?
    var sku: String?
    var price: CTWPrice?
}
