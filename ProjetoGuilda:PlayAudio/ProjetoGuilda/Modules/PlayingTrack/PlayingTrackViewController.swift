//
//  PlayingTrackViewController.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 28/10/20.
//

import UIKit
import AVKit

protocol PlayingTrackViewControllerInterface: NSObject {
    func updatePlayingTrack(to track: Int)
}

class PlayingTrackViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var fullScreenView: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonMinimize: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var buttonPlay: UIButton!
    
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var minimizeLabelTitle: UILabel!
    @IBOutlet weak var minimizeLabelSubtitle: UILabel!
    @IBOutlet weak var minimizeButtonPlay: UIButton!
    
    // MARK: - Properties
        
    private let viewModel: PlayingScreenViewModelInterface
    
    private var player: AVAudioPlayer?
    private var timer: Timer?
    private var viewTranslation = CGPoint(x: 0, y: 0)

    private var currentSong = 0
    private var totalOfSongs = 0
    private var trackDuration: Float = 0 {
        didSet {
            self.slider.minimumValue = 0
            self.slider.maximumValue = trackDuration
        }
    }
    
    // MARK: - Init method
    
    init(viewModel: PlayingScreenViewModelInterface,
         currentSong: Int,
         totalOfSongs: Int) {
        self.viewModel = viewModel
        self.currentSong = currentSong
        self.totalOfSongs = totalOfSongs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lyfe cicle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupToPlayTrack()
        configureUI()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        viewModel.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player = nil
        self.timer = nil
    }
    
    // MARK: - Class methods
    
    private func configureUI() {
        self.slider.value = 0
        self.audioView.isHidden = true
        self.audioView.layer.borderWidth = 1.0
        self.audioView.layer.borderColor = UIColor.blue.cgColor
        self.buttonClose.layer.cornerRadius = self.buttonClose.frame.width/2
        self.buttonClose.layer.borderColor = UIColor.red.cgColor
        self.buttonClose.layer.borderWidth = 1
        self.buttonMinimize.layer.cornerRadius = self.buttonClose.frame.width/2
        self.buttonMinimize.layer.borderColor = UIColor.blue.cgColor
        self.buttonMinimize.layer.borderWidth = 1
    }
    
    private func setupToPlayTrack() {
        timer?.invalidate()
        
        if player != nil {
            preparePlayerAndPlay()
        } else {
            initializePlayer()
            preparePlayerAndPlay()
        }
        configSliderTimer()
        configAudioStateIcon()
        configUIElementsToPlayingState()
    }
    
    private func initializePlayer() {
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            showAudioErrorAlert()
        }
    }
    
    private func preparePlayerAndPlay() {
        guard let trackURL = viewModel.track(for: currentSong) else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: trackURL)
            refreshAudioTrackDuration()
            playAudio()
        } catch {
            showAudioErrorAlert()
        }
    }
    
    private func refreshAudioTrackDuration() {
        if let duration = player?.duration {
            trackDuration = Float(duration)
        }
    }
    private func playAudio() {
        player?.prepareToPlay()
        player?.play()
    }
    
    private func showAudioErrorAlert() {
        let alertAction = UIAlertAction(title: "Erro de áudio", style: .default, handler: nil)
        let alert = UIAlertController(title: "Erro de áudio", message: "Não foi possível executar o aúdio. Tente novamente.", preferredStyle: .alert)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func configSliderTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    private func configAudioStateIcon() {
        let isPlayingAudio = player?.isPlaying ?? false
        if isPlayingAudio {
            setPauseIcon()
        } else {
            setPlayIcon()
        }
    }
    
    private func configUIElementsToPlayingState() {
        labelTitle.text = "Titulo avulso da faixa de audio"
        labelSubtitle.text = "Faixa \(currentSong+1)/\(totalOfSongs)"
        minimizeLabelTitle.text = "Ouvindo faixa \(currentSong+1)/\(totalOfSongs)"
        minimizeLabelSubtitle.text = "Faixa \(currentSong+1)/\(totalOfSongs)"
    }
    
    private func setPauseIcon() {
        let image = UIImage.init(systemName: "pause.fill")
        buttonPlay.setImage(image, for: .normal)
        minimizeButtonPlay.setImage(image, for: .normal)
    }
    
    private func setPlayIcon() {
        let image = UIImage.init(systemName: "play.fill")
        buttonPlay.setImage(image, for: .normal)
        minimizeButtonPlay.setImage(image, for: .normal)
    }
    
    private func nextTrack() {
        let isLastTrack = currentSong >= totalOfSongs-1
        if isLastTrack {
            configStopPlaying()
        } else {
            currentSong += 1
            setupToPlayTrack()
        }
    }
    
    private func configStopPlaying() {
        player?.stop()
        configAudioStateIcon()
    }
    
    @objc
    private func updateSlider() {
        guard let currentTime = player?.currentTime else { return }
        slider.value = Float(currentTime)
        verifyIfWillPlayNextTrack()
    }
    
    private func verifyIfWillPlayNextTrack() {
        let minimumAudioPercentToChangeTrack: Float = 0.99
        let valueToChangeTrack = minimumAudioPercentToChangeTrack * slider.maximumValue
        if slider.value > valueToChangeTrack {
            nextTrack()
        }
    }
    
}

private extension PlayingTrackViewController {
    //MARK: Screen Dismiss Methods
    
    @objc
    func handleDismiss(sender: UIPanGestureRecognizer) {
        guard !viewModel.isScreenMinimized else { return }
        viewTranslation = sender.translation(in: view)
        
        switch sender.state {
        case .changed:
            updateViewVerticalPosition()
        case .ended:
            let minimumTranslationToTransform: CGFloat = 200
            if viewTranslation.y < minimumTranslationToTransform {
                initalViewVerticalPosition()
            } else {
               minimizeView()
            }
        default:
            break
        }
    }
    
    func updateViewVerticalPosition() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
        })
    }
    
    func initalViewVerticalPosition() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.transform = .identity
        })
    }
    
    func minimizeView() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.transform = .identity
                        self.viewModel.isScreenMinimized = true
                       })
    }
}

private extension PlayingTrackViewController {
    
    //MARK: Actions

    @IBAction
    func buttonPlayPressed(_ sender: UIButton) {
        if player?.isPlaying ?? false {
            player?.pause()
        } else {
            player?.play()
        }
        configAudioStateIcon()
    }
    
    @IBAction
    func previousPressed(_ sender: UIButton) {
        if currentSong > 0 {
            currentSong -= 1
        }
        setupToPlayTrack()
    }
    
    @IBAction
    func nextPressed(_ sender: UIButton) {
        nextTrack()
    }
    
    @IBAction
    func sliderChanged(_ sender: UISlider) {
        player?.stop()
        player?.currentTime = TimeInterval(sender.value)
        player?.prepareToPlay()
        player?.play()
    }
    
    @IBAction
    func buttonClosePressed(_ sender: UIButton) {
        timer?.invalidate()
        viewModel.dismiss()
    }
    
    @IBAction
    func buttonMinimizePressed(_ sender: UIButton) {
        viewModel.isScreenMinimized = true
    }
    
    @IBAction
    func buttonMaximizePressed(_ sender: UIButton) {
        viewModel.isScreenMinimized = false
    }
}


extension PlayingTrackViewController: PlayingTrackViewControllerInterface {
    func updatePlayingTrack(to track: Int) {
        currentSong = track
        setupToPlayTrack()
    }
}

extension PlayingTrackViewController: PlayingScreenViewModelDelegate {
    func didChangeScreenState(isMinimized: Bool) {
        audioView.isHidden = !isMinimized
        fullScreenView.isHidden = isMinimized
    }

}
