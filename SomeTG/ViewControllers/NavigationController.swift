// NavigationController.swift

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        overrideUserInterfaceStyle = .dark
    }
}
