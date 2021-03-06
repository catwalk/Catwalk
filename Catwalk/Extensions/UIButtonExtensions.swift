//
//  Buttons.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

extension UIButton {
        
    func setGenieStyle(height: CGFloat = 50, width: CGFloat = 300, title: String, backgroundColor: UIColor = Customization.menuButtonBackgroundColor, fontColor: UIColor = Customization.menuButtonFontColor, padding: UIEdgeInsets? = nil) {
        setDimensions(height: height, width: width)
        layer.cornerRadius = height / 2
        self.backgroundColor = backgroundColor
        contentEdgeInsets = padding ?? UIEdgeInsets(top: 10, left: height, bottom: 10, right: height)
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont(name: Customization.lightFontName, size: 16) ?? UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: fontColor,
            ])

        setAttributedTitle(attributedText, for: .normal)
    }
}

