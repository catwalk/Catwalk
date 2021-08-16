//
//  CTWLook.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

struct CTWLook: Decodable {
    var items: [CTWLookItem] = []
}

struct CTWLookItem: Decodable {
    var weight: Float?
    var column: Int?
    var product: CTWProduct?
}
