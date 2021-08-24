//
//  CTWChatAttendanceReviewTableViewCell.swift
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWChatAttendanceReviewTableViewCell: UITableViewCell {
    
    var delegate: CTWAttendanceReviewDelegate?

    var lbMessage: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: Customization.boldFontName, size: 20)
        label.textColor = Customization.chatScreenAssistantMessageColor
        label.text = "Foi útil pra você?"
        return label
    }()
    
    lazy var btnPositiveReview: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "Sim")
        button.addTarget(self, action: #selector(positiveReviewAction), for: .touchUpInside)
        return button
    }()
    
    lazy var btnNegativeReview: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "Não")
        button.addTarget(self, action: #selector(negativeReviewAction), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellUI() {
        backgroundColor = .clear
        let buttonStackView = UIStackView(arrangedSubviews: [btnPositiveReview, btnNegativeReview])
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 24
        
        let itemsStackView = UIStackView(arrangedSubviews: [lbMessage, buttonStackView])
        itemsStackView.axis = .vertical
        itemsStackView.distribution = .fillProportionally
        itemsStackView.spacing = 36
        
        addSubview(itemsStackView)
        
        itemsStackView.fillSuperview()
    }
    
    @objc func positiveReviewAction() {
        delegate?.didReviewAttendance(positive: true)
    }
    
    @objc func negativeReviewAction() {
        delegate?.didReviewAttendance(positive: false)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width, height: 500)
    }
}
