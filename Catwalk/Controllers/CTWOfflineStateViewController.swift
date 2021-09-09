//
//  CTWOfflineStateViewController.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWOfflineStateViewController: CTWGenieContainerViewController {
    
    var lbGenieTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Customization.boldFontName, size: 26)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Parece que você está com problemas em sua conexão."
        return label
    }()
    
    lazy var btnDismiss: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "Ok")
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
   
    private func setupView() {
        btnBack.isHidden = true
        navigationController?.navigationBar.barStyle = .default
        view.backgroundColor = Customization.menuScreenBackgroundColor
        view.addSubview(lbGenieTitle)
        view.addSubview(btnDismiss)
        
        lbGenieTitle.setWidth(view.frame.width * 0.8)
        lbGenieTitle.centerX(inView: view, topAnchor: btnClose.bottomAnchor, paddingTop: 32)
        btnDismiss.centerX(inView: view, topAnchor: lbGenieTitle.bottomAnchor, paddingTop: 32)
    }
    
    override func close() {
        self.dismiss(animated: true)
    }
    
}
