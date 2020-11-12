//
//  HomeViewModel.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 27/10/20.
//

import Foundation

protocol HomeViewModelDelegate: class {
    func error()
    func success()
}

class HomeViewModel {
    
    let provider: HomeProviderDelegate
    let coordinator: HomeCoordinatorDelegate
    weak var delegate: HomeViewModelDelegate?
    
    private var audioContent: SongsDto?
    
    init(provider: HomeProviderDelegate,
         coordinator: HomeCoordinatorDelegate) {
        self.provider = provider
        self.coordinator = coordinator
    }
    
    // MARK: - Public methods
    
    func numberOfRows() -> Int {
        return audioContent?.songs?.count ?? 0
    }
    
    func cellContent(for index: Int) -> String {
        guard (audioContent?.songs ?? []).indices.contains(index) else {
            return ""
        }
        return audioContent?.songs?[index].title ?? ""
    }
    
    func callSongs() {
        provider.getInfos() { (songs) in
            self.audioContent = songs
            self.delegate?.success()
        } errorCallBack: { (_) in
            self.delegate?.error()
        }
    }
    
    func didClickPlayTrack(at index: Int) {
        guard let tracks = audioContent?.songs else {
            return
        }
        coordinator.showTrackScreen(tracks, currentSong: index)
    }
}
