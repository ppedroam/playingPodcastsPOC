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
    func playTrack(_ tracks: [TrackDto], newTrackIndex: Int)
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
    
    func playTrack(_ tracks: [TrackDto], newTrackIndex: Int) {
        let isPlayingAnyTrack = playingTrackController != nil
        
        if isPlayingAnyTrack {
            playingTrackController?.updatePlayingTrack(to: newTrackIndex)
        } else {
            initializePlayingTrackScreen(tracksList: tracks, newTrackIndex: newTrackIndex)
        }
    }
}

private extension HomeCoordinator {
    func initializePlayingTrackScreen(tracksList: [TrackDto], newTrackIndex: Int) {
        guard let viewController = viewController else { return }
        let data = PlayingScreenDataModel(tracks: tracksList, currentSong: newTrackIndex)
        do {
            let playingScreenController = try PlayingScreenBuilder.construct(tabBarController: tabBarController,
                                                                             navigationController: navigationController,
                                                                             parentViewController: viewController,
                                                                             data: data)
            playingTrackController = playingScreenController as? PlayingTrackViewController
            presentPlayingScreen()
        } catch {
            fatalError()
        }
       
    }
    
    func presentPlayingScreen() {
        if let tabBarController = tabBarController as? TabBarController,
           let controller = playingTrackController {
            tabBarController.presentAudioController(controller)
        }
    }
}
