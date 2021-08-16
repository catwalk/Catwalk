//
//  CTWLookCollectionViewCell.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit
import SDWebImage

class CTWLookCollectionViewCell: UICollectionViewCell {
    
    var look: CTWLook? {
        didSet {
            setupLayout(for: look)
        }
    }
    
    var lookContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    var leftColumn: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    var rightColumn: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
    }
    
    func setupCellUI() {
        backgroundColor = .white
        
        [lookContainer].forEach { viewItem in
            addSubview(viewItem)
        }
        
        leftColumn.translatesAutoresizingMaskIntoConstraints = false
        rightColumn.translatesAutoresizingMaskIntoConstraints = false
        
        lookContainer.addArrangedSubview(leftColumn)
        lookContainer.addArrangedSubview(rightColumn)
        
        lookContainer.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(for look: CTWLook?) {
        clearColumn(containerView: leftColumn)
        clearColumn(containerView: rightColumn)
        guard let look = look else { return }
        look.items.forEach { lookItem in
            guard let column = lookItem.column else { return }

            if column == 1 {
                leftColumn.addArrangedSubview(itemContainerFactory(lookItem: lookItem))
            } else if column == 2 {
                rightColumn.addArrangedSubview(itemContainerFactory(lookItem: lookItem))
            }
        }
    }
    
    func itemContainerFactory(lookItem: CTWLookItem) -> UIView{
        let weight =  CGFloat((lookItem.weight ?? 0)/5)
        let view = CTWLookContainerView()
        view.height = frame.height * weight
        if let image = lookItem.product?.image, image != "" {
            view.imageView.sd_setImage(with: URL(string: image))
        }
        
        view.backgroundColor = .clear
        return view
    }
    
    func clearColumn(containerView: UIView) {
        for view in containerView.subviews{
            view.removeFromSuperview()
        }
    }
}
