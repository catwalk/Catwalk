//
//  CTWGenieItemListingViewController.swift
//  Catwalk
//
//  Created by CTWLK on 9/29/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWGenieItemListingViewController: CTWGenieContainerViewController {
    // MARK: - Variables
    
    private let cellIdentifier = "clothingCell"
    
    var products: [CTWProduct] = [] {
        didSet {
            DispatchQueue.main.async {
                self.itemsTableView.reloadData()
            }
        }
    }
    
    lazy var itemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CTWClothingItemTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        setLightMode()
        lbTitle.text = "Suas sugestões"
        lbTitle.textColor = .black
        btnBack.setTitleColor(.black, for: .normal)
        btnClose.setTitleColor(.black, for: .normal)
        view.backgroundColor = .white
            
        [itemsTableView].forEach { itemView in
            view.addSubview(itemView)
        }
        
        itemsTableView.anchor(top: btnClose.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
        
        DispatchQueue.main.async {
            self.itemsTableView.reloadData()
        }
    }

}

extension CTWGenieItemListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CTWClothingItemTableViewCell
        cell.selectionStyle = .none
        
        if let product = products[safe: indexPath.row] {
            cell.lbHeadline.text = product.headline
            if let imageURL = product.image {
                cell.ivClothing.sd_setImage(with: URL(string: imageURL)!)
            }
            if let currentPriceInCents = product.price?.currentPriceInCents {
                cell.lbPrice.text = "R$ \(CTWAppUtils.formatNumberToDecimal(value: Double(currentPriceInCents/100)))"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked")
        if let sku = products[safe: indexPath.row]?.sizes?.first?.sku {
            let assistantViewController = navigationController?.viewControllers[0] as? CTWGenieViewController
            assistantViewController?.delegate?.didReturnSingleItem(sku: sku)
            self.navigationController?.dismiss(animated: true)
        }
    }
}
