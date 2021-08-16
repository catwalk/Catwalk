//
//  CTWChatMessage.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

enum CTWChatMessageType: Int, Decodable {
    case PlainText
    case Look
    case Similar
    case Review
}

enum ChatMessageSender: Int, Decodable {
    case User
    case Assistant
}

class CTWChatMessage: Decodable {
    var text: String?
    var type: CTWChatMessageType?
    var sender: ChatMessageSender?
    
    init(text: String, type: CTWChatMessageType, sender: ChatMessageSender) {
        self.text = text
        self.type = type
        self.sender = sender
    }
}
