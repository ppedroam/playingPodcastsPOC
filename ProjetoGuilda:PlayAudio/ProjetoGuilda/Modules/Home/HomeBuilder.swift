//
//  HomeBuilder.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 28/10/20.
//

import Foundation
import UIKit

protocol BuilderProtocol {
    static func construct<T>(tabBarController: UITabBarController,
                          navigationController: UINavigationController,
                          parentViewController: UIViewController,
                          data: T?) throws -> UIViewController
}

enum BuilderError: Error {
    case dataError
}

class HomeBuilder: BuilderProtocol {
    static func construct<T>(tabBarController: UITabBarController,
                          navigationController: UINavigationController,
                          parentViewController: UIViewController,
                          data: T?) throws -> UIViewController {
        let coordinator = HomeCoordinator(tabBarController: tabBarController,
                                          navigationController: navigationController,
                                          parentViewController: parentViewController)
        let provider = HomeProvider()
        let viewModel = HomeViewModel(provider: provider, coordinator: coordinator)
        let viewController = HomeViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        coordinator.viewController = viewController
        navigationController.viewControllers = [viewController]
        return viewController
    }
}
