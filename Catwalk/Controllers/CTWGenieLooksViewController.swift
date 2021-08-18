//
//  CTWGenieLooksViewController.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWGenieLooksViewController: CTWGenieContainerViewController {
    
    private let lookCellIdentifier = "lookCell"
    
    var genieLooksViewModel: CTWGenieLooksViewModel? {
        didSet {
            lbTitle.text = genieLooksViewModel?.looksCounterDescription
            lbLookPrice.text = genieLooksViewModel?.currentLookTotalPrice
        }
    }
    
    lazy var looksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var lbGenieDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: Customization.regularFontName, size: 18)
        label.numberOfLines = 0
        label.text = "Separei aqui algumas sugestões de look que podem te inspirar"
        return label
    }()
    
    var lbLookPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Customization.boldFontName, size: 20)
        return label
    }()
    
    lazy var btnBuyLook: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "personalize e compre", fontColor: Customization.generalButtonFontColor)
        button.addTarget(self, action: #selector(buyLook), for: .touchUpInside)
        button.backgroundColor = Customization.generalButtonBackgroundColor
        return button
    }()
    
    lazy var btnLikeLook: UIButton = {
        let button = UIButton(type: .system)
        let bundle = Bundle(for: CTWGenieLooksViewController.self)
        let imageIcon = UIImage(named: "genieLike", in: bundle, with: nil)?.withTintColor(Customization.generalButtonBackgroundColor, renderingMode: .alwaysOriginal)
        button.setImage(imageIcon, for: .normal)
        button.addTarget(self, action: #selector(likeLook), for: .touchUpInside)
        button.setDimensions(height: 50, width: 50)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    func setupScreen() {
        let lookButtonsStackView = UIStackView(arrangedSubviews: [btnBuyLook, btnLikeLook])
        lookButtonsStackView.axis = .horizontal
        lookButtonsStackView.distribution = .fillProportionally
        lookButtonsStackView.spacing = 16
        btnBuyLook.translatesAutoresizingMaskIntoConstraints = false
        btnLikeLook.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        view.addSubview(looksCollectionView)
        view.addSubview(lookButtonsStackView)
        view.addSubview(lbLookPrice)
        view.addSubview(lbGenieDescription)
        
        lbTitle.textColor = .black
        setLightMode()

        looksCollectionView.anchor(top: lbGenieDescription.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: lbLookPrice.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingBottom: 16)
        looksCollectionView.showsHorizontalScrollIndicator = false
        lookButtonsStackView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 32, paddingRight: 32)
        lookButtonsStackView.setHeight(50)
        lbLookPrice.anchor(bottom: lookButtonsStackView.topAnchor, right: view.rightAnchor, paddingBottom: 12, paddingRight: 32)
        lbGenieDescription.anchor(top: btnClose.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
        
        looksCollectionView.register(CTWLookCollectionViewCell.self, forCellWithReuseIdentifier: lookCellIdentifier)
        looksCollectionView.delegate = self
        looksCollectionView.dataSource = self
        looksCollectionView.isPagingEnabled = true
    }
    
    @objc func buyLook() {
        if let productIds = genieLooksViewModel?.currentLook?.items.map({ $0.product?.productId ?? "" }).filter({ $0 != "" }) {
            let loader = CTWAppUtils.createLoader(title: "Carregando")
            self.present(loader, animated: true)
            
            CTWNetworkManager.shared.fetchProductsInfo(for: productIds) { (result: Result<[CTWProduct], CTWNetworkManager.APIServiceError>) in
                switch result {
                    case .success(let products):
                        DispatchQueue.main.async { [weak self] in
                            loader.dismiss(animated: true) {
                                let genieShoppingListViewController = CTWGenieShoppingListViewController()
                                genieShoppingListViewController.shoppingMode = .look
                                genieShoppingListViewController.genieShoppingListViewModel = CTWGenieShoppingListViewModel(products: products)
                                self?.navigationController?.pushViewController(genieShoppingListViewController, animated: true)
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
    
    @objc func likeLook() {
        if let productIds = genieLooksViewModel?.currentLook?.items.map({ $0.product?.productId ?? "" }).filter({ $0 != "" }) {
            let loader = CTWAppUtils.createLoader(title: "Carregando")
            self.present(loader, animated: true)
            
            CTWNetworkManager.shared.likeLook(with: productIds) { (result: Result<CTWDefaultResponse, CTWNetworkManager.APIServiceError>) in
                switch result {
                case .success( _):
                        DispatchQueue.main.async {
                            loader.dismiss(animated: true)
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
}

extension CTWGenieLooksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genieLooksViewModel?.totalLooks ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let look = genieLooksViewModel?.looks[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: lookCellIdentifier, for: indexPath) as! CTWLookCollectionViewCell
        cell.look = look
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        genieLooksViewModel?.currentLookIndex = Int(floorf(Float(scrollView.contentOffset.x / scrollView.frame.width)))
    }
    
}

extension CTWGenieLooksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: looksCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

