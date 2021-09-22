//
//  CTWGenieShoppingListViewController.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

enum CTWGenieShoppingMode {
    case look
    case size
}

protocol CTWLKAssistantShoppingDelegate {
    func didChangeSizeForShoppingItem(productId: String, sku: String, identifier: String)
}

class CTWGenieShoppingListViewController: CTWGenieContainerViewController {
    
    var shoppingMode: CTWGenieShoppingMode = .size {
        didSet {
            if (shoppingMode == .look) {
                lbTotalPrice.isHidden = false
                divider.isHidden = false
            } else {
                lbTotalPrice.isHidden = true
                divider.isHidden = true
            }
        }
    }
    
    private let cellIdentifier = "clothingCell"
        
    var genieShoppingListViewModel: CTWGenieShoppingListViewModel?
    
    var priceInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return stackView
    }()
    
    lazy var clothesTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CTWShoppingClothingItemTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    var divider: UIView = {
        let view = UIView()
        view.setHeight(1)
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    var lbTotalPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Customization.boldFontName, size: 20)
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    lazy var btnSendToCart: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "comprar", fontColor: Customization.generalButtonFontColor)
        button.addTarget(self, action: #selector(sendToCart), for: .touchUpInside)
        button.backgroundColor = Customization.generalButtonBackgroundColor
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setLightMode()
        lbTitle.text = shoppingMode == .look ? "Escolha seus tamanhos" : "Escolha seu tamanho"
        lbTitle.textColor = .black
        btnBack.setTitleColor(.black, for: .normal)
        btnClose.setTitleColor(.black, for: .normal)
        view.backgroundColor = .white
        
        priceInfoStackView.addArrangedSubview(divider)
        priceInfoStackView.addArrangedSubview(lbTotalPrice)
            
        [clothesTableView, priceInfoStackView].forEach { itemView in
            view.addSubview(itemView)
        }
        
        clothesTableView.anchor(top: btnClose.bottomAnchor, left: view.leftAnchor, bottom: priceInfoStackView.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
        
        if shoppingMode == .look {
            view.addSubview(btnSendToCart)
            priceInfoStackView.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: btnSendToCart.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 40, paddingBottom: 20, paddingRight: 40)
            btnSendToCart.centerX(inView: view)
            btnSendToCart.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
        } else {
            priceInfoStackView.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 40, paddingBottom: 32, paddingRight: 40)
        }
        
        lbTotalPrice.text = genieShoppingListViewModel?.totalPrice
        clothesTableView.reloadData()
    }
    
    @objc func sendToCart() {
        let assistantViewController = navigationController?.viewControllers[0] as? CTWGenieViewController
        assistantViewController?.delegate?.didReturnShoppingItems(skus: genieShoppingListViewModel?.shoppingProducts.map({ $0.sku ?? "" }) ?? [])
        self.navigationController?.dismiss(animated: true)
    }

}

extension CTWGenieShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genieShoppingListViewModel?.totalProducts ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CTWShoppingClothingItemTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.editable = shoppingMode == .look
        if let item = genieShoppingListViewModel?.getProduct(at: indexPath.row) {
            cell.shoppingClothingViewModel = CTWShoppingClothingViewModel(product: item, delegate: self)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shoppingMode == .size, let sku = genieShoppingListViewModel?.shoppingProducts[safe: indexPath.row]?.sku {
            let assistantViewController = navigationController?.viewControllers[0] as? CTWGenieViewController
            assistantViewController?.delegate?.didReturnShoppingItems(skus: [sku])
            self.navigationController?.dismiss(animated: true)
        }
    }
}

extension CTWGenieShoppingListViewController: CTWShoppingClothingItemTableViewCellDelegate {
    func didRemoveItemWith(productId: String?) {
        genieShoppingListViewModel?.removeProductByProductId(productId)
        if let totalProducts = genieShoppingListViewModel?.totalProducts, totalProducts > 0 {
            clothesTableView.reloadData()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension CTWGenieShoppingListViewController: CTWLKAssistantShoppingDelegate {
    func didChangeSizeForShoppingItem(productId: String, sku: String, identifier: String) {
        if let index = genieShoppingListViewModel?.shoppingProducts.firstIndex(where: {$0.productId == productId}) {
            genieShoppingListViewModel?.products[index].chosenSKU = sku
            genieShoppingListViewModel?.shoppingProducts[index].sku = sku
            genieShoppingListViewModel?.shoppingProducts[index].identifier = identifier
        }
    }
}

