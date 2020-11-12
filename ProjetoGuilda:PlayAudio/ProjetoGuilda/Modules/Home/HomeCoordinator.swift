//
//  HomeCoordinator.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 28/10/20.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: class {
    var tabBarController: UITabBarController { get set }
    var navigationController: UINavigationController { get set}
    var parentViewController: UIViewController { get set }
    var viewController: UIViewController? { get set }
}

protocol HomeCoordinatorDelegate: CoordinatorProtocol {
    func showTrackScreen(_ tracks: [TrackDto], currentSong: Int)
}

class HomeCoordinator: HomeCoordinatorDelegate {
    var viewController: UIViewController?
    var parentViewController: UIViewController
    var tabBarController: UITabBarController
    var navigationController: UINavigationController
    weak var playingTrackController: PlayingTrackViewController?
    
    init(tabBarController: UITabBarController,
         navigationController: UINavigationController,
         parentViewController: UIViewController) {
        self.tabBarController = tabBarController
        self.navigationController = navigationController
        self.parentViewController = parentViewController
    }
    
    // MARK: - Public methods
    
    func showTrackScreen(_ tracks: [TrackDto], currentSong: Int) {
        if playingTrackController != nil {
            playingTrackController?.updatePlayingTrack(to: currentSong)
            return
        }
        
        guard let viewController = viewController else { return }
        let data = PlayingScreenDataModel(tracks: tracks, currentSong: currentSong)
        let playingScreenController = try? PlayingScreenBuilder.construct(tabBarController: tabBarController,
                                                            navigationController: navigationController,
                                                            parentViewController: viewController,
                                                            data: data)
        guard let playingScreenController_ = playingScreenController as? PlayingTrackViewController else {
            return
        }
        playingTrackController = playingScreenController_
        if let tabBarController = tabBarController as? TabBarController {
            tabBarController.presentAudioController(playingScreenController_)
        }
    }
    
}
