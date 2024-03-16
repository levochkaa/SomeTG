// RootViewController.swift

import UIKit
import Combine
import TDLibKit

class RootViewController: BaseViewController, ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @PublishedUserDefault("loggedIn") private var loggedIn = false
    
    let chatsViewController = ChatsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "SomeTG"
        
        setPublishers()
        
        addViewController(chatsViewController)
        
        view.backgroundColor = .black
    }
    
    func setPublishers() {
        $loggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loggedIn in
                guard let self else { return }
                if loggedIn {
                    if let loginVC = presentedViewController as? LoginViewController {
                        loginVC.dismiss(animated: true)
                    }
                } else {
                    if presentedViewController as? LoginViewController != nil {} else {
                        present(LoginViewController(), animated: true)
                    }
                }
            }
            .store(in: &cancellables)
        
        nc.publisher(&cancellables, for: .ready) { [weak self] _ in
            guard let self else { return }
            loggedIn = true
        }
        
        nc.mergeMany(&cancellables, [.closed, .closing, .loggingOut, .waitPhoneNumber, .waitCode, .waitPassword]) { [weak self] _ in
            guard let self else { return }
            loggedIn = false
        }
    }
}
