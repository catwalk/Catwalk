//
//  CTWGenieLooksViewModel.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

struct CTWGenieLooksViewModel {
    var looks: [CTWLook]
    var totalLooks: Int {
        return looks.count
    }
    var currentLookIndex: Int?
    var looksCounterDescription: String {
        guard let currentLookIndex = currentLookIndex else { return "" }
        return "Look \(currentLookIndex + 1) de \(looks.count)"
    }
    var currentLook: CTWLook? {
        guard let currentLookIndex = currentLookIndex else { return nil }
        return looks[currentLookIndex]
    }
    
    var currentLookTotalPrice: String {
        guard let currentLookIndex = currentLookIndex else { return "" }
        let look = looks[currentLookIndex]
        let totalPrice = look.items.reduce(0) { $0 + ($1.product?.price?.currentPriceInCents ?? 0.0) }
        return "por R$ \(CTWAppUtils.formatNumberToDecimal(value: Double(totalPrice/100)))"
    }
    
    init(looks: [CTWLook]) {
        self.looks = looks
        if looks.count > 0 {
            currentLookIndex = 0
        }
    }
}
