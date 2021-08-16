//
//  CTWGenieChatViewController.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWGenieChatViewController: CTWGenieContainerViewController {
    
    private var messages: [CTWChatMessage] = []
    private var startingMessage: String?
    
    private let userMessageCell = "userMessageCell"
    private let assistantMessageCell = "assistantMessageCell"
    
    lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CTWChatAssistantMessageTableViewCell.self, forCellReuseIdentifier: assistantMessageCell)
        tableView.register(CTWChatUserMessageTableViewCell.self, forCellReuseIdentifier: userMessageCell)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    lazy var tfMessage: UITextField = {
        let textField = UITextField()
        textField.textColor = Customization.chatScreenAssistantMessageColor
        textField.delegate = self
        textField.font = UIFont(name: Customization.regularFontName, size: 18)
        textField.textAlignment = .right
        textField.attributedPlaceholder =
            NSAttributedString(string: "digite algo aqui...", attributes: [.foregroundColor: UIColor.F8F8F8])
        return textField
    }()
    
    lazy var btnSendMessage: UIButton = {
        let button = UIButton(type: .system)
        button.setGenieStyle(title: "enviar")
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    convenience init() {
        self.init(startingMessage: nil)
    }

    init(startingMessage: String?) {
        self.startingMessage = startingMessage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
            // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupScreen()
    }
    
    func setupScreen() {
        view.backgroundColor = Customization.chatScreenBackgroundColor
        lbTitle.text = "Converse comigo"
        
        [chatTableView, btnSendMessage, tfMessage].forEach { itemView in
            view.addSubview(itemView)
        }
        
        chatTableView.anchor(top: lbTitle.bottomAnchor, left: view.leftAnchor, bottom: tfMessage.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 35, paddingBottom: 20, paddingRight: 35)
        btnSendMessage.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
        btnSendMessage.centerX(inView: view)
        tfMessage.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: btnSendMessage.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 64, paddingBottom: 16, paddingRight: 64)
        
        
        if let startingMessage = startingMessage {
            fetchMessage(for: startingMessage)
        } else {
            messages.append(CTWChatMessage(text: "Oi! Eu sou a Cá, sua assistente de moda da C&A. Vamos conversar?", type: .PlainText, sender: .Assistant))
            updateMessagesList()
        }
    }
    
    private func updateMessagesList() {
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
        }
    }
    
    @objc func sendMessage() {
        if let text = tfMessage.text, text != "" {
            tfMessage.text = ""
            fetchMessage(for: text)
        }
    }
    
    func fetchMessage(for text: String) {
        messages.append(CTWChatMessage(text: text, type: .PlainText, sender: .User))
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
            self.view.endEditing(true)
            self.fetchResponse(for: text)
        }
    }
    
    func fetchResponse(for message: String) {
        let focusedSKU: String? = (navigationController?.viewControllers.first as? CTWGenieViewController)?.focusedSKU
        
        let loader = CTWAppUtils.createLoader(title: "Carregando")
//        self.present(loader, animated: true)
        
        CTWNetworkManager.shared.fetchChatMessageResponse(for: message, with: focusedSKU) { (result: Result<CTWChatMessage, CTWNetworkManager.APIServiceError>) in
            switch result {
                case .success(let chatResponse):
                    DispatchQueue.main.async { [weak self] in
                        chatResponse.sender = .Assistant
                        chatResponse.type = .PlainText
                        self?.messages.append(chatResponse)
                        self?.chatTableView.reloadData()
                        let indexPath = IndexPath(item: (self?.messages.count ?? 0) - 1, section: 0)
                        self?.chatTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
      self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }

}

extension CTWGenieChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMessage()
        return true
    }
}

extension CTWGenieChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellSender = messages[indexPath.row].sender else { return UITableViewCell()}
        
        switch cellSender {
        case .User:
            let cell = tableView.dequeueReusableCell(withIdentifier: userMessageCell, for: indexPath) as! CTWChatUserMessageTableViewCell
            cell.selectionStyle = .none
            cell.lbMessage.text = messages[indexPath.row].text
            return cell
        case .Assistant:
            let cell = tableView.dequeueReusableCell(withIdentifier: assistantMessageCell, for: indexPath) as! CTWChatAssistantMessageTableViewCell
            cell.selectionStyle = .none
            cell.lbMessage.text = messages[indexPath.row].text
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

