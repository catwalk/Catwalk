//
//  CTWLookContainerView.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWLookContainerView: UIView {
    var height: CGFloat = 1.0
    
    var delegate: CTWLookItemDelegate?
    
    var btnContainer: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        return button
    }()
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    var infoIcon: UIButton = {
        let button = UIButton()
        let bundle = Bundle(for: CTWLookContainerView.self)
        let imageIcon = UIImage(named: "genieInfo", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        button.setImage(imageIcon, for: .normal)
        button.tintColor = .LightGrey
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        addSubview(imageView)
        addSubview(infoIcon)
        addSubview(btnContainer)
        
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        infoIcon.anchor(top: imageView.topAnchor, left: imageView.leftAnchor)
        btnContainer.fillSuperview()
    }
    
    override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize(width: superSize.width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
