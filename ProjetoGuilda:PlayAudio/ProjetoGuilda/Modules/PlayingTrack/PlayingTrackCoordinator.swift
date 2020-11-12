//
//  PlayingTrackViewModel.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 28/10/20.
//

import Foundation
import UIKit

protocol PlayingScreenCoordinatorDelegate: CoordinatorProtocol {
    func dismiss()
    func minimize()
    func maximize()
}

class PlayingScreenCoordinator: PlayingScreenCoordinatorDelegate {
    weak var viewController: UIViewController?
    unowned var parentViewController: UIViewController
    unowned var tabBarController: UITabBarController
    unowned var navigationController: UINavigationController
    
    init(tabBarController: UITabBarController,
         navigationController: UINavigationController,
         parentViewController: UIViewController) {
        self.tabBarController = tabBarController
        self.navigationController = navigationController
        self.parentViewController = parentViewController
        
    }
    
    deinit {
        print("COORDINATOR DEINIT")
        print("COORDINATOR DEINIT")
    }
    
    func dismiss() {
//        viewController?.dismiss(animated: true, completion: nil)
        if let tabBarController = tabBarController as? TabBarController {
            tabBarController.removeAudioController()
        }
    }
    
    func minimize() {
        if let tabBarController = tabBarController as? TabBarController {
            tabBarController.minimizeAudioController()
        }
    }
    
    func maximize() {
        if let tabBarController = tabBarController as? TabBarController {
            tabBarController.maximize()
        }
    }
}
