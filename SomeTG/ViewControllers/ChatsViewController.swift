// ChatsViewController.swift

import UIKit
import Combine
import TDLibKit

class ChatsViewController: BaseViewController {
    let tableView = UITableView()
    var chats = [CustomChat]()
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        nc.publisher(&cancellables, for: .ready) { [weak self] _ in
            guard let self else { return }
            Task.main {
                let chatIds = try await td.getChats(chatList: .chatListMain, limit: 100).chatIds
                let customChats = try await chatIds.asyncCompactMap { try await self.getCustomChat(from: $0) }
                self.chats = customChats
                self.tableView.reloadData()
            }
        }
    }
    
    func getCustomChat(from id: Int64) async throws -> CustomChat? {
        let chat = try await td.getChat(chatId: id)
        
        if case .chatTypePrivate(let chatTypePrivate) = chat.type {
            let user = try await td.getUser(userId: chatTypePrivate.userId)
            if case .userTypeRegular = user.type {
                return CustomChat(
                    chat: chat,
                    positions: chat.positions,
                    unreadCount: chat.unreadCount,
                    user: user,
                    lastMessage: chat.lastMessage,
                    draftMessage: chat.draftMessage
                )
            }
        }
        
        return nil
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        tableView.register(ChatsTableCell.self, forCellReuseIdentifier: ChatsTableCell.identifier)
        tableView.dataSource = self
    }
}

extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatsTableCell.identifier, for: indexPath)
        var configuration = UIListContentConfiguration.cell()
        configuration.text = chats[indexPath.row].chat.title
        cell.contentConfiguration = configuration
        return cell
    }
}

class ChatsTableCell: UITableViewCell {
    static let identifier = String(describing: ChatsTableCell.self)
}
