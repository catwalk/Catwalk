//
//  CTWShoppingClothingItemTableViewCell.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWClothingItemTableViewCell: UITableViewCell {
        
    var ivClothing: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var lbHeadline: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Customization.boldFontName, size: 16)
        label.numberOfLines = 3
        return label
    }()
    
    var lbPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Customization.regularFontName, size: 16)
        return label
    }()
    
    var btnSeeDetails: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(height: 40, title: "ver detalhes", backgroundColor: Customization.generalButtonBackgroundColor, fontColor: .white, padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
        button.isUserInteractionEnabled = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellUI() {
        [ivClothing, lbHeadline, lbPrice, btnSeeDetails].forEach { itemView in
            contentView.addSubview(itemView)
        }
        
        lbHeadline.anchor(top: ivClothing.topAnchor, left: ivClothing.rightAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
        lbPrice.anchor(top: lbHeadline.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 16)
        ivClothing.centerY(inView: self)
        ivClothing.anchor(left: leftAnchor, paddingLeft: 8)
        ivClothing.setDimensions(height: 175, width: 125)
        btnSeeDetails.anchor(left: ivClothing.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        
    }
}
