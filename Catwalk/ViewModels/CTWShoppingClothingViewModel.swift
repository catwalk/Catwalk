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
        return "R$ \(CTWAppUtils.formatNumberToDecimal(value: Double((product.price?.currentPriceInCents ?? 0)/100)))"
    }
    
    var imageURL: URL? {
        return URL(string: product.image ?? "")
    }
    
    var sizesCount: Int {
        return product.sizes?.count ?? 0
    }
    
    func sizeAt(index: Int) -> String {
        return product.sizes?[index].identifier ?? ""
    }
    
    func textForSizeAt(index: Int) -> String {
        return "Tamanho \(product.sizes?[index].identifier ?? "")"
    }
    
    func updateSize(at index: Int) {
        if let productId = product.productId, let sku = product.sizes?[index].sku, let identifier = product.sizes?[index].identifier {
            delegate?.didChangeSizeForShoppingItem(productId: productId, sku: sku, identifier: identifier)
        }
    }
}
