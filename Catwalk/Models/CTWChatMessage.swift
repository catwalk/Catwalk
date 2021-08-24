//
//  CTWChatMessage.swift
//  Copyright © 2021 CATWALK. All rights reserved.
//

enum CTWChatMessageType: Int, Decodable {
    case PlainText = 1
    case Look
    case Similar
    case AvailableColors
    case AvailableSizes
    case TrendingClothing
    case Buy
    case Review
}

enum ChatMessageSender: Int, Decodable {
    case User = 1
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
