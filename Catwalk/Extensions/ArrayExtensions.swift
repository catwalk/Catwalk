//
//  ArrayExtensions.swift
//  Copyright © 2021 CATWALK. All rights reserved.
//

extension Array {
    subscript (safe index: Index) -> Element? {
        0 <= index && index < count ? self[index] : nil
    }
}
