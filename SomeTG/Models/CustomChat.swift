// CustomChat.swift

import Foundation
import TDLibKit

class CustomChat {
    var chat: Chat
    var positions: [ChatPosition]
    var unreadCount: Int
    var user: User
    var lastMessage: Message?
    var draftMessage: DraftMessage?
    
    init(
        chat: Chat,
        positions: [ChatPosition],
        unreadCount: Int,
        user: User,
        lastMessage: Message?,
        draftMessage: DraftMessage?
    ) {
        self.chat = chat
        self.positions = positions
        self.unreadCount = unreadCount
        self.user = user
        self.lastMessage = lastMessage
        self.draftMessage = draftMessage
    }
}
