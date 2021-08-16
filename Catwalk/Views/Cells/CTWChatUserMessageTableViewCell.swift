//
//  CTWChatUserMessageTableViewCell.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWChatUserMessageTableViewCell: UITableViewCell {

    var lbMessage: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = UIFont(name: Customization.italicFontName, size: 20)
        label.textColor = Customization.chatScreenUserMessageColor
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellUI() {
        backgroundColor = .clear
        addSubview(lbMessage)
        lbMessage.centerY(inView: self)
        lbMessage.anchor(left: leftAnchor, right: rightAnchor)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width, height: 80)
    }
}
