//
//  CTWGenieCreateLookColorOptionsViewController.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

struct LookColorOption {
    var colorId: Int?
    var description: String?
    var color: UIColor?
}

class CTWGenieCreateLookColorOptionsViewController: CTWGenieContainerViewController {
    
    
    let colorOptions: [LookColorOption] = {
        var options: [LookColorOption] = [
            LookColorOption(colorId: 1, description: "preto", color: .black),
            LookColorOption(colorId: 2, description: "branco", color: .white),
            LookColorOption(colorId: 3, description: "tons azuis", color: .BabyBlue),
            LookColorOption(colorId: 4, description: "tons verdes", color: .DeepGrey),
            LookColorOption(colorId: 5, description: "tons terra", color: .LightBrown),
            LookColorOption(colorId: 6, description: "acinzentados", color: .LightGrey)
        ]
        
        return options
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = Customization.menuScreenBackgroundColor.withAlphaComponent(0.9)
        lbTitle.text = "Montar um look"
        
        let optionsStackView = UIStackView(arrangedSubviews: colorOptions.map({ colorOptionButtonFactory($0) }))
        optionsStackView.axis = .vertical
        optionsStackView.distribution = .fillEqually
        optionsStackView.spacing = 24
        
        view.addSubview(optionsStackView)
        
        optionsStackView.centerX(inView: view, topAnchor: lbTitle.bottomAnchor, paddingTop: 64)
    }
    
    private func colorOptionButtonFactory(_ option: LookColorOption) -> UIButton {
        let colorIcon = UIView()
        colorIcon.setDimensions(height: 20, width: 20)
        colorIcon.layer.cornerRadius = 10
        colorIcon.backgroundColor = option.color
        
        
        let button = UIButton(type: .system)
        button.setGenieStyle(title: option.description ?? "")
        
        button.leftIcon(view: colorIcon)
        button.tag = option.colorId ?? -1
        button.addTarget(self, action: #selector(chooseColor), for: .touchUpInside)
        return button
    }
    
    @objc func chooseColor(_ sender: UIButton) {
        let loader = CTWAppUtils.createLoader(title: "Carregando")
        self.present(loader, animated: true)
        
        CTWNetworkManager.shared.fetchCombinationsBy(hue: sender.tag) { (result: Result<[CTWLook], CTWNetworkManager.APIServiceError>) in
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
}

extension UIButton {
    func leftIcon(view: UIView) {
        self.addSubview(view)
        view.anchor(left: self.leftAnchor, paddingLeft: 20)
        view.centerY(inView: self)
   }
}
