//
//  CTWShoppingClothingViewModel.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

struct CTWShoppingClothingViewModel {
    var product: CTWProduct
    var delegate: CTWLKAssistantShoppingDelegate?
    
    var headline: String? {
        return product.headline
    }
    
    var currentPrice: String? {
        guard let currentPriceInCents = product.price?.currentPriceInCents else { return nil }
        return "R$ \(CTWAppUtils.formatNumberToDecimal(value: Double(currentPriceInCents/100)))"
    }
    
    var imageURL: URL? {
        guard let imageURL = product.image else { return nil}
        return URL(string: imageURL)
    }
    
    var sizesCount: Int {
        return product.sizes?.count ?? 0
    }
    
    func sizeAt(index: Int) -> String {
        return product.sizes?[safe: index]?.identifier ?? ""
    }
    
    func textForSizeAt(index: Int) -> String {
        guard let sizeIdentifier = product.sizes?[safe: index]?.identifier else { return "" }
        return "Tamanho \(sizeIdentifier)"
    }
    
    func currentTextSize() -> String {
        let index = product.sizes?.firstIndex(where: {$0.sku == product.chosenSKU})
        guard let sizeIdentifier = product.sizes?[safe: index ?? 0]?.identifier else { return "" }
        return "Tamanho \(sizeIdentifier)"
    }
    
    mutating func updateSize(at index: Int) {
        if let productId = product.productId, let sku = product.sizes?[index].sku, let identifier = product.sizes?[index].identifier {
            product.chosenSKU = sku
            delegate?.didChangeSizeForShoppingItem(productId: productId, sku: sku, identifier: identifier)
        }
    }
}
