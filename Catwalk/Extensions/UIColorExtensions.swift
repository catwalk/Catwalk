//
//  Colors.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

extension UIColor {
    
    //COLORS
    static let Emerald = UIColor(netHex: 0x00aca4)
    static let FontPurple = UIColor(netHex: 0xcc2c8d)
    
    static let ProcessBlackU = UIColor(netHex: 0x232323)
    static let P1792U = UIColor(netHex: 0xE7E7E7)
    static let P1698U = UIColor(netHex: 0x979797)
    static let P16915U = UIColor(netHex: 0x575757)
    static let P108C = UIColor(netHex: 0xA2D07D)
    static let P4916U = UIColor(netHex: 0xB50000)
    static let F8F8F8 = UIColor(netHex: 0xF8F8F8)
    
    
    //Color Table
    static let ShadesOfGrey = UIColor(netHex: 0x555555)
    static let DeepGrey = UIColor(netHex: 0x202020)
    static let LightGrey = UIColor(netHex: 0xCBCBCB)
    static let DarkRed = UIColor(netHex: 0xAB2727)
    static let Coral = UIColor(netHex: 0xFF7F50)
    static let Burgundy = UIColor(netHex: 0x800020)
    static let LightYellow = UIColor(netHex: 0xfffc83)
    static let BrightYellow = UIColor(netHex: 0xffec00)
    static let Mustard = UIColor(netHex: 0xffdb58)
    static let BrightGreen = UIColor(netHex: 0xa2ff00)
    static let Lime = UIColor(netHex: 0x32cd32)
    static let Olive = UIColor(netHex: 0x808000)
    static let ArmyGreen = UIColor(netHex: 0x7cb259)
    static let Mint = UIColor(netHex: 0x98ff98)
    static let LightBlue = UIColor(netHex: 0xadd8e6)
    static let BabyBlue = UIColor(netHex: 0x89cff0)
    static let Turquoise = UIColor(netHex: 0x30d5c8)
    static let NavyBlue = UIColor(netHex: 0x000080)
    static let DarkBlue = UIColor(netHex: 0x00008b)
    static let Purple = UIColor(netHex: 0x800080)
    static let Lilac = UIColor(netHex: 0xc8a2c8)
    static let Fuchsia = UIColor(netHex: 0xff00ff)
    static let Orange = UIColor(netHex: 0xffa500)
    static let Peach = UIColor(netHex: 0xffe5b4)
    static let Salmon = UIColor(netHex: 0xff8c69)
    static let Tangerine = UIColor(netHex: 0xf28500)
    static let Pink = UIColor(netHex: 0xffc0cb)
    static let Pale = UIColor(netHex: 0xfadadd)
    static let Magenta = UIColor(netHex: 0xff00ff)
    static let Nude = UIColor(netHex: 0xf5f5dc)
    static let Beige = UIColor(netHex: 0xb2a286)
    static let Camel = UIColor(netHex: 0xc19a6b)
    static let Brown = UIColor(netHex: 0xa52a2a)
    static let LightBrown = UIColor(netHex: 0xb5651d)
    static let DarkBrown = UIColor(netHex: 0x654321)
    static let Gold = UIColor(netHex: 0xffd700)
    static let Silver = UIColor(netHex: 0xc0c0c0)
    static let Bronze = UIColor(netHex: 0xcd7f32)
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    
}
