//
//  CTWLook.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

class CTWLook: Decodable {
    var items: [CTWLookItem] = []
    var likedLook: Bool?
    
    init() {}
    
    init(items: [CTWLookItem]) {
        self.items = items
    }
    
    init(likedLook: Bool) {
        self.likedLook = likedLook
    }
}

struct CTWLookItem: Decodable {
    var weight: Float?
    var column: Int?
    var product: CTWProduct?
}
