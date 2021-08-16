//
//  ViewController.swift
//  CatwalkExamples
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit
import Catwalk

class ViewController: UIViewController {

    lazy var btnGlobalGenieOpener: UIButton = {
            var button = UIButton(type: .system)
            button.setTitle("Global Genie State", for: .normal)
            button.addTarget(self, action: #selector(openGlobalGenieState), for: .touchUpInside)
            return button
        }()
        
        lazy var btnFocusedGenieOpener: UIButton = {
            var button = UIButton(type: .system)
            button.setTitle("Focused Item Genie State", for: .normal)
            button.addTarget(self, action: #selector(openFocusedGenieState), for: .touchUpInside)
            return button
        }()
        
        lazy var btnOfflineGenieState: UIButton = {
            var button = UIButton(type: .system)
            button.setTitle("Offline Genie State", for: .normal)
            button.addTarget(self, action: #selector(openOfflineGenieState), for: .touchUpInside)
            return button
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            
            let generalButtonsStackView = UIStackView(arrangedSubviews: [btnGlobalGenieOpener, btnFocusedGenieOpener, btnOfflineGenieState])
            generalButtonsStackView.axis = .vertical
            generalButtonsStackView.distribution = .fillEqually
            generalButtonsStackView.spacing = 24
                    
            view.addSubview(generalButtonsStackView)
            generalButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
            generalButtonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            generalButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        
        @objc func openGlobalGenieState() {
            let context = CTWAssistantContext()
            context.delegate = self
            context.hostViewController = self
            context.presentAssistant()
        }
        
        @objc func openFocusedGenieState() {
            let context = CTWAssistantContext()
            context.delegate = self
            context.focusedSKU = "2512084"
            context.hostViewController = self
            context.presentAssistant()
        }
        
        @objc func openOfflineGenieState() {
            let context = CTWAssistantContext()
            context.hostViewController = self
            context.presentOfflineState()
        }
}

extension ViewController: CTWAssistantDelegate {
    
    func didReturnShoppingItems(skus: [String]) {
        print("PARTNER: Shopping Items: \(skus)")
    }
    func didReturnMultipleItems(skus: [String]) {
        print("PARTNER: Multiple Items: \(skus)")
    }
    
    func didReturnSingleItem(sku: String) {
        print("PARTNER: Single Item: \(sku)")
    }
}

