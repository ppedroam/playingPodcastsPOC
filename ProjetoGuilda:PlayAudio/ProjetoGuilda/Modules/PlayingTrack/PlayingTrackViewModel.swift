//
//  PlayingTrackViewModel.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 28/10/20.
//

import Foundation

protocol PlayingScreenViewModelInterface: class {
    var delegate: PlayingScreenViewModelDelegate? { get set }
    var isScreenMinimized: Bool { get set }
    func track(for index: Int) -> URL?
    func dismiss()
}

protocol PlayingScreenViewModelDelegate: NSObject {
    func didChangeScreenState(isMinimized: Bool)
}

class PlayingScreenViewModel: PlayingScreenViewModelInterface {
    
    let coordinator: PlayingScreenCoordinatorDelegate
    weak var delegate: PlayingScreenViewModelDelegate?
    private let tracks: [TrackDto]
    
    init(coordinator: PlayingScreenCoordinatorDelegate,
         tracks: [TrackDto]) {
        self.coordinator = coordinator
        self.tracks = tracks
    }
    
    var isScreenMinimized: Bool = false {
        didSet {
            didChangeScreenPresentationState()
        }
    }
    
    func track(for index: Int) -> URL? {
        guard tracks.indices.contains(index) else { return nil }
        guard tracks.count > index,
              let url = self.convertBase64ToAudio(tracks[index].data, title: tracks[index].title) else {
            return nil
        }
        return url
    }
    
    func dismiss() {
        coordinator.dismiss()
    }
}

private extension PlayingScreenViewModel {
    func didChangeScreenPresentationState() {
        delegate?.didChangeScreenState(isMinimized: isScreenMinimized)
        
        if isScreenMinimized {
            coordinator.minimize()
        } else {
            coordinator.maximize()
        }
    }
    
    func convertBase64ToAudio(_ base64: String?, title: String?) -> URL? {
        guard let base64 = base64, let title = title else { return nil }
        let audioData_ = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        guard let audioData = audioData_ else { return nil }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let randomNumber = Int.random(in: 0..<555555)
        let filename = paths[0].appendingPathComponent("\(title)\(randomNumber).mp3")
        do {
            try audioData.write(to: filename, options: .atomicWrite)
            return filename
        } catch {
            print("error write")
        }
        return nil
    }
}

