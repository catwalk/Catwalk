//
//  CTWShoppingClothingItemTableViewCell.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

protocol CTWShoppingClothingItemTableViewCellDelegate {
    func didRemoveItemWith(productId: String?)
}

class CTWShoppingClothingItemTableViewCell: UITableViewCell {
    
    var delegate: CTWShoppingClothingItemTableViewCellDelegate?
    
    var editable: Bool = false {
        didSet {
            if(editable) {
                tfSize.layer.borderColor = UIColor.black.cgColor
                tfSize.layer.cornerRadius = 8
                tfSize.layer.borderWidth = 1
            } else {
                btnRemove.isHidden = true
                tfSize.isUserInteractionEnabled = false
            }
        }
    }
    
    var shoppingClothingViewModel: CTWShoppingClothingViewModel? {
        didSet {
            lbHeadline.text = shoppingClothingViewModel?.headline
            lbPrice.text = shoppingClothingViewModel?.currentPrice
            ivClothing.sd_setImage(with: shoppingClothingViewModel?.imageURL)
            tfSize.text = shoppingClothingViewModel?.currentTextSize()
            self.pickerView.reloadAllComponents()
        }
    }
        
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
        label.numberOfLines = 2
        return label
    }()
    
    var lbPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Customization.regularFontName, size: 16)
        return label
    }()
    
    lazy var tfSize: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.tintColor = .clear
        return textField
    }()
    
    lazy var btnRemove: UIButton = {
        let button = UIButton(type: .system)
        let bundle = Bundle(for: CTWShoppingClothingItemTableViewCell.self)
        let imageIcon = UIImage(named: "genieRemove", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        button.setImage(imageIcon, for: .normal)
        button.tintColor = .red
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
        return button
    }()
    
    lazy var pickerView = UIPickerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellUI() {
        [ivClothing, lbHeadline, lbPrice, tfSize, btnRemove].forEach { itemView in
            contentView.addSubview(itemView)
        }
        
        lbHeadline.anchor(top: ivClothing.topAnchor, left: ivClothing.rightAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 64)
        btnRemove.anchor(top: ivClothing.topAnchor, right: rightAnchor, paddingTop: -20, paddingRight: 0)
        lbPrice.anchor(top: lbHeadline.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 16)
        ivClothing.centerY(inView: self)
        ivClothing.anchor(left: leftAnchor, paddingLeft: 8)
        ivClothing.setDimensions(height: 150, width: 125)
        
        tfSize.anchor(left: ivClothing.rightAnchor, bottom: ivClothing.bottomAnchor, right: rightAnchor, paddingLeft: 20, paddingRight: 20)
        tfSize.setHeight(40)
        
        pickerView.delegate = self
        tfSize.inputView = pickerView
    }
    
    @objc func removeItem() {
        delegate?.didRemoveItemWith(productId: shoppingClothingViewModel?.product.productId)
    }
}


extension CTWShoppingClothingItemTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shoppingClothingViewModel?.sizesCount ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return shoppingClothingViewModel?.sizeAt(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(editable) {
            tfSize.text = shoppingClothingViewModel?.textForSizeAt(index: row)
            shoppingClothingViewModel?.updateSize(at: row)
            self.endEditing(true)
        }
    }
}
