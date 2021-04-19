//
//  TabBarController.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 27/10/20.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    private var audioViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTabBar()
        initializeControllers()
        configureTabBarIcons()
    }
}

private extension TabBarController {
    func configureTabBar() {
        self.tabBar.barTintColor = .white
        self.tabBar.unselectedItemTintColor = .systemGray
        self.tabBar.tintColor = .gray
        self.tabBar.backgroundColor = .white
        
        self.tabBar.isTranslucent = false
        self.tabBar.layer.shadowOffset = CGSize.zero
        self.tabBar.layer.shadowRadius = 2
        self.tabBar.layer.shadowColor = UIColor.gray.cgColor
        self.tabBar.layer.shadowOpacity = 1
    }
    
    func initializeControllers() {
        let homeController = try? HomeBuilder.construct(tabBarController: self,
                                                        navigationController: NavigationController(),
                                                        parentViewController: self,
                                                        data: AnyObject.self)
        let controllers: [UIViewController] = [
            homeController ?? UIViewController(),
            NavigationController(rootViewController: SecondViewController())
        ]
        
        self.viewControllers = controllers.map {
            if let navigationController = $0.navigationController {
                return navigationController
            }
            return $0
        }
    }
    
    func configureTabBarIcons() {
        viewControllers?.forEach({ (viewController) in
            if viewController.isKind(of: HomeViewController.self) {
                configureHomeTabBarIcon(viewController)
            }
            if let nav = viewController as? NavigationController,
               let secondVC = nav.viewControllers.first as? SecondViewController {
                configureSecondController(secondVC)
            }
        })
    }
    
    func configureHomeTabBarIcon(_ homeController: UIViewController) {
        let imageSelected = UIImage(named: "home-fill")?.icon(size: 30)
        let image = UIImage(named: "home")?.icon(size: 30)
        let item = UITabBarItem(title: nil, image: image, selectedImage: imageSelected)
        homeController.tabBarItem = item
        homeController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
    }
    
    func configureSecondController(_ secondController: UIViewController) {
        let imageSelected = UIImage(named: "music-fill")?.icon(size: 30)
        let image = UIImage(named: "music")?.icon(size: 30)
        let item = UITabBarItem(title: nil, image: image, selectedImage: imageSelected)
        secondController.tabBarItem = item
        secondController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
    }
}
    
extension TabBarController {
    
    func presentAudioController(_ viewController: UIViewController) {
        audioViewController = viewController
        let frame = view.frame
        let statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect()
        let height = frame.height - statusBarFrame.height
        viewController.view.frame = CGRect(x: frame.minX,
                                           y: frame.maxY,
                                           width: frame.width,
                                           height: height)
        viewController.view.layoutSubviews()
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        UIView.animate(withDuration: 0.4) {
            viewController.view.frame = CGRect(x: frame.minX,
                                               y: frame.minY + statusBarFrame.maxY,
                                               width: frame.width,
                                               height: height)
            viewController.view.layoutIfNeeded()
        }
    }
    
    func removeAudioController() {
        audioViewController?.dismiss(animated: true, completion: {
            self.audioViewController?.removeFromParent()
            self.audioViewController?.view.removeFromSuperview()
            self.audioViewController = nil
        })
    }
}

