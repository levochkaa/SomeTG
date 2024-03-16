// NotificationCenter.swift

import Foundation
import Combine

let nc = NotificationCenter()

extension NotificationCenter {
    func publisher(
        _ cancellables: inout Set<AnyCancellable>,
        for name: Notification.Name,
        main: Bool = false,
        _ perform: @escaping (Publisher.Output) -> Void
    ) {
        if main {
            self
                .publisher(for: name)
                .receive(on: DispatchQueue.main)
                .sink { notification in perform(notification) }
                .store(in: &cancellables)
        } else {
            self
                .publisher(for: name)
                .sink { notification in perform(notification) }
                .store(in: &cancellables)
        }
    }
    
    func post(name: Notification.Name) {
        post(name: name, object: nil)
    }
    
    func publisher(for name: Notification.Name) -> NotificationCenter.Publisher {
        publisher(for: name, object: nil)
    }
    
    func mergeMany(
        _ cancellables: inout Set<AnyCancellable>,
        _ names: [Notification.Name],
        main: Bool = false,
        _ perform: @escaping (Publisher.Output) -> Void
    ) {
        Publishers.MergeMany(names.map { publisher(for: $0) })
            .receive(on: DispatchQueue.main)
            .sink { notification in perform(notification) }
            .store(in: &cancellables)
    }
}
