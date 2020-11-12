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
        let viewFrame = tabBarController.view.frame
        let maxY = tabBarController.tabBar.frame.minY
        let height: CGFloat = 74
        UIView.animate(withDuration: 0.4) {
            self.viewController?.view.frame = CGRect(x: viewFrame.minX,
                                                          y: maxY-height,
                                                          width: viewFrame.width,
                                                          height: height)
            self.tabBarController.view.layoutIfNeeded()
        }
    }
    
    func maximize() {
        let screenFrame = tabBarController.view.bounds
        let statusBarFrame = tabBarController.view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect()
        let height = screenFrame.height - statusBarFrame.height
        UIView.animate(withDuration: 0.4) {
            self.viewController?.view.frame = CGRect(x: screenFrame.minX,
                                                     y: screenFrame.minY + statusBarFrame.maxY,
                                                     width: screenFrame.width,
                                                     height: height)
            self.tabBarController.view.layoutIfNeeded()
        }
//        completion: { (_) in
////            self.viewController?.view.transform = .identity
//        }
    }
}
