//
//  CTWGenieShoppingListViewModel.swift
//  Catwalk
//
//  Created by CTWLK on 8/18/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

struct CTWGenieShoppingListViewModel {
    var products: [CTWProduct] {
        didSet {
            shoppingProducts = products.map({ CTWShoppingProduct(productId: $0.productId, sku: $0.sizes?[0].sku, identifier: $0.sizes?[0].identifier)})
        }
    }
    
    var shoppingProducts: [CTWShoppingProduct] = []
    
    var totalProducts: Int {
        return products.count
    }
    
    var totalPrice: String? {
        let totalPrice = products.reduce(0) { $0 + ($1.price?.currentPriceInCents ?? 0.0) }
        if(totalPrice > 0) {
            return "total R$ \(CTWAppUtils.formatNumberToDecimal(value: Double(totalPrice/100)))"
        }
        return nil
    }
    
    func getProduct(at index: Int) -> CTWProduct? {
        return products[safe: index]
    }
    
    func getProductIndex(by productId: String?) -> Int? {
        guard let productId = productId else { return nil }
        return products.firstIndex(where: { $0.productId == productId })
    }
    
    mutating func removeProductByProductId(_ productId: String?) {
        guard let index = getProductIndex(by: productId) else { return }
        products.remove(at: index)
    }
}
