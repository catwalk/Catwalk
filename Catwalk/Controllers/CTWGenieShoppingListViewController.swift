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
    
    var shoppingMode: CTWGenieShoppingMode = .size
    
    private let cellIdentifier = "clothingCell"
    
    var shoppingProducts: [CTWShoppingProduct]?
    
    var products: [CTWProduct]? {
        didSet {
            shoppingProducts = products?.map({ CTWShoppingProduct(productId: $0.productId, sku: $0.sizes?[0].sku, identifier: $0.sizes?[0].identifier)})
            clothesTableView.reloadData()
        }
    }
    
    lazy var clothesTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CTWShoppingClothingItemTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
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
        lbTitle.text = "Escolha seus tamanhos"
        lbTitle.textColor = .black
        btnBack.setTitleColor(.black, for: .normal)
        btnClose.setTitleColor(.black, for: .normal)
        view.backgroundColor = .white
        [clothesTableView, btnSendToCart].forEach { itemView in
            view.addSubview(itemView)
        }
        
        clothesTableView.anchor(top: btnClose.bottomAnchor, left: view.leftAnchor, bottom: btnSendToCart.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingBottom: 16, paddingRight: 20)
        btnSendToCart.centerX(inView: view)
        btnSendToCart.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
    }
    
    @objc func sendToCart() {
        let genieVC = navigationController?.viewControllers[0] as? CTWGenieViewController
        genieVC?.delegate?.didReturnShoppingItems(skus: shoppingProducts?.map({ $0.sku ?? "" }) ?? [])
        self.dismiss(animated: true)
    }

}

extension CTWGenieShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CTWShoppingClothingItemTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.editable = shoppingMode == .look
        if let item = products?[indexPath.row] {
            cell.shoppingClothingViewModel = CTWShoppingClothingViewModel(product: item, delegate: self)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shoppingMode == .size, let sku = shoppingProducts?[indexPath.row].sku {
            let genieVC = navigationController?.viewControllers[0] as? CTWGenieViewController
            genieVC?.delegate?.didReturnSingleItem(sku: sku)
            self.dismiss(animated: true)
        }
    }
}

extension CTWGenieShoppingListViewController: CTWShoppingClothingItemTableViewCellDelegate {
    func didRemoveItemWith(productId: String?) {
        let productIndex = products?.firstIndex(where: { $0.productId == productId })
        guard let index = productIndex else { return }
        products?.remove(at: index)
        clothesTableView.reloadData()
    }
}

extension CTWGenieShoppingListViewController: CTWLKAssistantShoppingDelegate {
    func didChangeSizeForShoppingItem(productId: String, sku: String, identifier: String) {
        if let index = shoppingProducts?.firstIndex(where: {$0.productId == productId}) {
            shoppingProducts?[index].sku = sku
            shoppingProducts?[index].identifier = identifier
        }
    }
}

