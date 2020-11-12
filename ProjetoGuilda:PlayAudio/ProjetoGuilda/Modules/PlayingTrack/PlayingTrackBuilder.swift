//
//  PlayingTrackViewModel.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 28/10/20.
//

import Foundation
import UIKit

class PlayingScreenBuilder: BuilderProtocol {
    static func construct<T>(tabBarController: UITabBarController,
                             navigationController: UINavigationController,
                             parentViewController: UIViewController,
                             data: T?) throws -> UIViewController  {
        let coordinator = PlayingScreenCoordinator(tabBarController: tabBarController,
                                                   navigationController: navigationController,
                                                   parentViewController: parentViewController)
        guard let data = data as? PlayingScreenDataModel else {
            throw BuilderError.dataError
        }
        let viewModel = PlayingScreenViewModel(coordinator: coordinator, tracks: data.tracks)
        let viewController = PlayingTrackViewController(viewModel: viewModel, currentSong: data.currentSong, totalOfSongs: data.tracks.count)
        coordinator.viewController = viewController
        return viewController
    }
}

struct PlayingScreenDataModel {
    let tracks: [TrackDto]
    let currentSong: Int
}
