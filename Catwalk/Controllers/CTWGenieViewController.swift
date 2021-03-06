//
//  CTWGenieViewController.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit
import Network

enum GenieMode {
    case focusedClothing
    case general
}

public protocol CTWAssistantDelegate {
    func didReturnShoppingItems(skus: [String])
    func didReturnSingleItem(sku: String)
}

class CTWGenieViewController: CTWGenieContainerViewController {
        
    var focusedSKU: String?
    var delegate: CTWAssistantDelegate?
    var mode: GenieMode = .general
    var loader: UIAlertController?
    
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    var lbGenieTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Customization.boldFontName, size: 26)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Coisas que eu posso ajudar você"
        return label
    }()
    
    lazy var btnTrendingClothes: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "ver tendências")
        button.addTarget(self, action: #selector(fetchTrendingClothing), for: .touchUpInside)
        return button
    }()
    
    lazy var btnTrendingLooks: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "looks em alta")
        button.addTarget(self, action: #selector(fetchTrendingLooks), for: .touchUpInside)
        return button
    }()
    
    lazy var btnCreateLook: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "montar um look")
        button.addTarget(self, action: #selector(openCreateLookOptions), for: .touchUpInside)
        return button
    }()
    
    lazy var btnFocusedSKUAskSomething: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "perguntar algo")
        button.addTarget(self, action: #selector(openChat), for: .touchUpInside)
        return button
    }()
    
    lazy var btnGeneralAskSomething: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "perguntar algo")
        button.addTarget(self, action: #selector(openChat), for: .touchUpInside)
        return button
    }()
    
    lazy var btnFindSimilar: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "achar peça parecida")
        button.addTarget(self, action: #selector(fetchSimilarItems), for: .touchUpInside)
        return button
    }()
    
    lazy var btnCombine: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "looks com esta peça")
        button.addTarget(self, action: #selector(openLook), for: .touchUpInside)
        return button
    }()
    
    lazy var btnClothingDetails: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "detalhes do produto")
        button.addTarget(self, action: #selector(showItemDetails), for: .touchUpInside)
        return button
    }()
    
    lazy var btnMoreColors: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "tem outras cores?")
        button.addTarget(self, action: #selector(fetchMoreColors), for: .touchUpInside)
        return button
    }()
    
    lazy var btnMoreSizes: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "tem outros tamanhos?")
        button.addTarget(self, action: #selector(fetchAvailableSizes), for: .touchUpInside)
        return button
    }()
    
    convenience init() {
        self.init(focusedSKU: nil)
    }

    init(focusedSKU: String?) {
        self.focusedSKU = focusedSKU
        mode = focusedSKU != nil ? .focusedClothing : .general
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.isHidden = true
        btnClose.isHidden = true
        setupView()
        setupSession()
    }
        
    func setupSession() {
        CTWNetworkManager.shared.fetchSessionInfo { (result: Result<CTWSession, CTWNetworkManager.APIServiceError>) in
            switch result {
                case .success(let session):
                    GenieAPI.sessionId = session.id
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func renderOptions() {
        self.setupOptions()
    }
    
    func isFocusedSKUAvailable(sku: String?, checker: @escaping (Bool) -> Void) {
        guard let focusedSKU = focusedSKU else { return checker(false) }
    
        CTWNetworkManager.shared.checkItemAvailability(sku: focusedSKU) { (result: Result<CTWAvailability, CTWNetworkManager.APIServiceError>) in
            switch result {
                case .success(let availability):
                    self.closeLoader {
                        return checker(availability.available ?? false)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.closeLoader {
                        return checker(false)
                    }
            }
        }
    }
    
    private func closeLoader(completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.loader?.dismiss(animated: true, completion: completion)
            self.loader = nil
        }
    }
   
    private func setupView() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = Customization.menuScreenBackgroundColor.withAlphaComponent(0.9)
        loader = CTWAppUtils.createLoader(title: "Carregando")
        if let loader = loader {
            self.present(loader, animated: true) { [weak self] in
                self?.initializeOptions()
            }
        }
    }
    
    private func initializeOptions() {
        if Reachability.isConnectedToNetwork() {
            if self.mode == .general {
                self.closeLoader {
                    self.renderOptions()
                }
            } else {
                self.isFocusedSKUAvailable(sku: self.focusedSKU) { available in
                    if available == false {
                        self.mode = .general
                        self.focusedSKU = nil
                    }
                    self.renderOptions()
                }
            }
        } else {
            self.closeLoader {
                DispatchQueue.main.async {
                    let offlineStateViewController = CTWOfflineStateViewController()
                    self.navigationController?.pushViewController(offlineStateViewController, animated: false)
                }
            }
        }
    }
    
    private func setupOptions() {
        btnClose.isHidden = false
        let generalButtonsStackView = UIStackView(arrangedSubviews: [btnTrendingClothes, btnCreateLook, btnGeneralAskSomething])
        let focusedClothingButtonsStackView = UIStackView(arrangedSubviews: [btnFindSimilar, btnCombine, btnClothingDetails, btnMoreColors, btnMoreSizes, btnFocusedSKUAskSomething])
        
        let currentStackView = mode == .focusedClothing ? focusedClothingButtonsStackView : generalButtonsStackView
        currentStackView.axis = .vertical
        currentStackView.distribution = .fillEqually
        currentStackView.spacing = 24
        
        view.addSubview(lbGenieTitle)
        view.addSubview(currentStackView)
        
        lbGenieTitle.setWidth(view.frame.width * 0.8)
        lbGenieTitle.centerX(inView: view, topAnchor: btnClose.bottomAnchor, paddingTop: 16)
        currentStackView.centerX(inView: view, topAnchor: lbGenieTitle.bottomAnchor, paddingTop: 32)
    }
    
    @objc func openLook() {
        guard let focusedSKU = focusedSKU else { return }
        let loader = CTWAppUtils.createLoader(title: "Carregando")
        self.present(loader, animated: true)
        
        CTWNetworkManager.shared.fetchLooks(for: focusedSKU) { (result: Result<[CTWLook], CTWNetworkManager.APIServiceError>) in
            switch result {
                case .success(let looks):
                    let filteredLooks = looks
                    DispatchQueue.main.async { [weak self] in
                        loader.dismiss(animated: true) {
                            if(filteredLooks.count > 0){
                                let looksViewController = CTWGenieLooksViewController()
                                looksViewController.genieLooksViewModel = CTWGenieLooksViewModel(looks: filteredLooks)
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
    
    // MARK: Focused Clothing Actions
    
    @objc func fetchTrendingClothing() {
        let loader = CTWAppUtils.createLoader(title: "Carregando")
        self.present(loader, animated: true)
        
        CTWNetworkManager.shared.fetchTrendingSKUs { (result: Result<[String], CTWNetworkManager.APIServiceError>) in
            switch result {
                case .success(let trendingSKUs):
                   CTWNetworkManager.shared.fetchProductsInfo(skus: trendingSKUs) { (infoResult) in
                        switch infoResult {
                            case .success(let items):
                                DispatchQueue.main.async {
                                    loader.dismiss(animated: true) {
                                        if items.count > 0 {
                                            let genieNavigationController = self.navigationController as? CTWAssistantNavigationController
                                            genieNavigationController?.showListOfItems(products: items)
                                        } else {
                                            CTWAppUtils.showAlert(title: Customization.defaultErrorTitle, message: Customization.noTrendingItemsErrorMessage, host: self)
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
    
    @objc func fetchTrendingLooks() {
        let looksViewController = CTWGenieLooksViewController()
        navigationController?.pushViewController(looksViewController, animated: true)
    }
    
    @objc func fetchSimilarItems() {
        guard let focusedSKU = focusedSKU else { return }
        let loader = CTWAppUtils.createLoader(title: "Carregando")
        self.present(loader, animated: true)
        
        CTWNetworkManager.shared.fetchSimilars(for: focusedSKU) { (result: Result<[String], CTWNetworkManager.APIServiceError>) in
            switch result {
                case .success(let similars):
                    CTWNetworkManager.shared.fetchProductsInfo(skus: similars) { (infoResult) in
                        switch infoResult {
                            case .success(let items):
                                DispatchQueue.main.async {
                                    loader.dismiss(animated: true) {
                                        if items.count > 0 {
                                            let genieNavigationController = self.navigationController as? CTWAssistantNavigationController
                                            genieNavigationController?.showListOfItems(products: items)
                                        } else {
                                            CTWAppUtils.showAlert(title: Customization.defaultErrorTitle, message: Customization.noSimilarsErrorMessage, host: self)
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
    
    @objc func showItemDetails() {
        let chatViewController = CTWGenieChatViewController(startingMessage: "Detalhes")
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    @objc func fetchMoreColors() {
        guard let focusedSKU = focusedSKU else { return }
        let loader = CTWAppUtils.createLoader(title: "Carregando")
        self.present(loader, animated: true)
        
        CTWNetworkManager.shared.fetchAvailableColors(for: focusedSKU) { (result: Result<[String], CTWNetworkManager.APIServiceError>) in
            switch result {
                case .success(let colorSKUs):
                    if colorSKUs.count > 0 {
                        CTWNetworkManager.shared.fetchProductsInfo(skus: colorSKUs) { (infoResult) in
                            switch infoResult {
                                case .success(let items):
                                    DispatchQueue.main.async {
                                        loader.dismiss(animated: true) {
                                            if items.count > 0 {
                                                let genieNavigationController = self.navigationController as? CTWAssistantNavigationController
                                                genieNavigationController?.showListOfItems(products: items)
                                            } else {
                                                CTWAppUtils.showAlert(title: Customization.defaultErrorTitle, message: Customization.noColorsErrorMessage, host: self)
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
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            loader.dismiss(animated: true) {
                                CTWAppUtils.showAlert(title: Customization.defaultErrorTitle, message: Customization.noColorsErrorMessage, host: self)
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
    
    @objc func fetchAvailableSizes() {
        guard let focusedSKU = focusedSKU else { return }
        let loader = CTWAppUtils.createLoader(title: "Carregando")
        self.present(loader, animated: true)
        
        CTWNetworkManager.shared.fetchProductInfoBy(sku: focusedSKU) { (result: Result<CTWProduct, CTWNetworkManager.APIServiceError>) in
            switch result {
                case .success(let product):
                    DispatchQueue.main.async { [weak self] in
                        loader.dismiss(animated: true) {
                            if let sizes = product.sizes, sizes.count > 0 {
                                let genieShoppingListViewController = CTWGenieShoppingListViewController()
                                genieShoppingListViewController.genieShoppingListViewModel = CTWGenieShoppingListViewModel(products: sizes.map({ CTWProduct(headline: product.headline, productId: product.productId, image: product.image, price: product.price, sizes: [$0]) }))
                                self?.navigationController?.pushViewController(genieShoppingListViewController, animated: true)
                            } else {
                                CTWAppUtils.showAlert(title: Customization.defaultErrorTitle, message: Customization.noSizesErrorMessage, host: self)
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
    
    // MARK: General Mode Actions
    
    @objc func openCreateLookOptions() {
        let chatViewController = CTWGenieCreateLookGlobalOptionsViewController()
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    @objc func openChat() {
        let chatViewController = CTWGenieChatViewController()
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
}
