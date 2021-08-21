//
//  CTWGenieContainerViewController.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWGenieContainerViewController: UIViewController {
    
    var lbTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Customization.boldFontName, size: 22)
        label.textColor = Customization.menuScreenTitleColor
        return label
    }()
    
    lazy var btnBack: UIButton = {
        let button = UIButton(type: .system)
        let bundle = Bundle(for: CTWGenieContainerViewController.self)
        let imageIcon = UIImage(named: "genieBack", in: bundle, with: nil)?.withTintColor(Customization.menuButtonBackgroundColor, renderingMode: .alwaysOriginal)
        button.setImage(imageIcon, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()
    
    lazy var btnClose: UIButton = {
        let button = UIButton(type: .system)
        let bundle = Bundle(for: CTWGenieContainerViewController.self)
        let imageIcon = UIImage(named: "genieClose", in: bundle, with: nil)?.withTintColor(Customization.menuButtonBackgroundColor, renderingMode: .alwaysOriginal)
        button.setImage(imageIcon, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        
        [btnClose, btnBack, lbTitle].forEach { itemView in
            view.addSubview(itemView)
        }

        btnBack.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 20)
        btnBack.centerY(inView: btnClose)
        btnClose.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingRight: 20)
        lbTitle.centerX(inView: view)
        lbTitle.centerY(inView: btnClose)
    }
    
    public func setLightMode() {
        btnClose.setImage(btnClose.imageView?.image?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        btnBack.setImage(btnBack.imageView?.image?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    public func setDarkMode() {
        btnClose.setImage(btnClose.imageView?.image?.withTintColor(Customization.menuButtonBackgroundColor, renderingMode: .alwaysOriginal), for: .normal)
        btnBack.setImage(btnBack.imageView?.image?.withTintColor(Customization.menuButtonBackgroundColor, renderingMode: .alwaysOriginal), for: .normal)
    }

    @objc func close() {
        let assistantController = navigationController 
        navigationController?.dismiss(animated: true)
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }

}

