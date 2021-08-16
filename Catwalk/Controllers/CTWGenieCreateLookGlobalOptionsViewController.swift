//
//  CTWGenieCreateLookGlobalOptionsViewController.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWGenieCreateLookGlobalOptionsViewController: CTWGenieContainerViewController {
    
    lazy var btnTrendingClothingLooks: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "look com top 10")
        button.addTarget(self, action: #selector(fetchLooksForTrendingClothing), for: .touchUpInside)
        return button
    }()
    
    lazy var btnChooseColor: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "escolher uma cor")
        button.addTarget(self, action: #selector(openLookColorOptions), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = Customization.menuScreenBackgroundColor.withAlphaComponent(0.9)
        lbTitle.text = "Montar um look"
        
        let optionsStackView = UIStackView(arrangedSubviews: [btnTrendingClothingLooks, btnChooseColor])
        optionsStackView.axis = .vertical
        optionsStackView.distribution = .fillEqually
        optionsStackView.spacing = 24
        
        view.addSubview(optionsStackView)
        
        optionsStackView.centerX(inView: view, topAnchor: lbTitle.bottomAnchor, paddingTop: 64)
    }
    
    @objc func fetchLooksForTrendingClothing() {
        print("DEBUG: fetchLooksForTrendingClothing")
        let loader = CTWAppUtils.createLoader(title: "Carregando")
        self.present(loader, animated: true)
        
        CTWNetworkManager.shared.fetchTrendingClothingAsLooks { (result: Result<[CTWLook], CTWNetworkManager.APIServiceError>) in
            switch result {
                case .success(let looks):
                    DispatchQueue.main.async { [weak self] in
                        loader.dismiss(animated: true) {
                            if(looks.count > 0) {
                                let looksViewController = CTWGenieLooksViewController()
                                looksViewController.genieLooksViewModel = CTWGenieLooksViewModel(looks: looks)
                                self?.navigationController?.pushViewController(looksViewController, animated: true)
                            } else {
                                CTWAppUtils.showAlert(title: Customization.defaultErrorTitle, message: Customization.noLooksErrorMessage, host: self)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async { [weak self] in
                        loader.dismiss(animated: true) {
                            CTWAppUtils.showAlert(title: Customization.defaultErrorTitle, message: Customization.defaultErrorMessage, host: self)
                        }
                    }
            }
        }
    }
    
    @objc func openLookColorOptions() {
        let colorOptionsViewController = CTWGenieCreateLookColorOptionsViewController()
        navigationController?.pushViewController(colorOptionsViewController, animated: true)
    }
}

