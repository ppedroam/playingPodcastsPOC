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
        self.view.backgroundColor = .white
        self.tabBar.barTintColor = .white
        self.tabBar.unselectedItemTintColor = .systemGray
        self.tabBar.tintColor = .gray
        self.tabBar.backgroundColor = .white
        
        self.tabBar.isTranslucent = false
        self.tabBar.layer.shadowOffset = CGSize.zero
        self.tabBar.layer.shadowRadius = 2
        self.tabBar.layer.shadowColor = UIColor.gray.cgColor
        self.tabBar.layer.shadowOpacity = 1
        
        self.configureTabBar()
    }
    
    private func configureTabBar() {
        
        let homeController = try? HomeBuilder.construct(tabBarController: self,
                                                        navigationController: NavigationController(),
                                                        parentViewController: self,
                                                        data: AnyObject.self)
        let controllers: [UIViewController] = [
            homeController ?? UIViewController(),
            SecondViewController()
        ]
        
        self.viewControllers = controllers.map {
            if let navigationController = $0.navigationController {
                navigationController.viewControllers = [$0]
                return navigationController
            }
            return $0
        }
        
        controllers.forEach({ (vc) in
            
            if vc.isKind(of: HomeViewController.self) {
                let imageSelected = UIImage(named: "home-fill")?.icon(size: 30)
                let image = UIImage(named: "home")?.icon(size: 30)
                let item = UITabBarItem(title: nil, image: image, selectedImage: imageSelected)
                vc.tabBarItem = item
                vc.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
            }
            
            if vc.isKind(of: SecondViewController.self) {
                let imageSelected = UIImage(named: "music-fill")?.icon(size: 30)
                let image = UIImage(named: "music")?.icon(size: 30)
                let item = UITabBarItem(title: nil, image: image, selectedImage: imageSelected)
                vc.tabBarItem = item
                vc.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
            }
        })
    }
    
    // MARK: - Public methods
    
    
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
    
    func minimizeAudioController() {
        let viewFrame = view.frame
        let maxY = tabBar.frame.minY
        let height: CGFloat = 74
        UIView.animate(withDuration: 0.4) {
            self.audioViewController?.view.frame = CGRect(x: viewFrame.minX,
                                                     y: maxY-height,
                                                     width: viewFrame.width,
                                                     height: height)
            self.view.layoutIfNeeded()
        }
    }
    
    func maximize() {
        let screenFrame = view.bounds
        let statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect()
        let height = screenFrame.height - statusBarFrame.height
        UIView.animate(withDuration: 0.4) {
            self.audioViewController?.view.frame = CGRect(x: screenFrame.minX,
                                                     y: screenFrame.minY + statusBarFrame.maxY,
                                                     width: screenFrame.width,
                                                     height: height)
            self.view.layoutIfNeeded()
        }
    }
}

