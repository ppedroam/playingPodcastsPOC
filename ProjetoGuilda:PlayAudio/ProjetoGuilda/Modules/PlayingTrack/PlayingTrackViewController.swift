//
//  PlayingTrackViewController.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 28/10/20.
//

import UIKit
import AVKit

protocol PlayingTrackViewControllerInterface: class {
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
    
    let viewModel: PlayingScreenViewModelInterface
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
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
    
    deinit {
        print("VIEWCONTROLLER DEINIT")
        print("VIEWCONTROLLER DEINIT")
    }
    
    // MARK: - Lyfe cicle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.slider.value = 0
        self.playTrack()
        self.audioView.isHidden = true
        self.audioView.layer.borderWidth = 1.0
        self.audioView.layer.borderColor = UIColor.blue.cgColor
        self.buttonClose.layer.cornerRadius = self.buttonClose.frame.width/2
        self.buttonClose.layer.borderColor = UIColor.blue.cgColor
        self.buttonClose.layer.borderWidth = 1
        self.buttonMinimize.layer.cornerRadius = self.buttonClose.frame.width/2
        self.buttonMinimize.layer.borderColor = UIColor.blue.cgColor
        self.buttonMinimize.layer.borderWidth = 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player = nil
        self.timer = nil
        print("VIEWCONTROLLER DISAPPEAR")
    }
    
    // MARK: - Class methods
    
    private func playTrack() {
        timer?.invalidate()
        if player?.isPlaying ?? false {
            guard let trackURL = viewModel.track(for: currentSong) else {
                return
            }
            player = try? AVAudioPlayer(contentsOf: trackURL)
            if let duration = player?.duration {
                trackDuration = Float(duration)
            }
            player?.play()
        } else {
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                guard let trackURL = viewModel.track(for: currentSong) else {
                    return
                }
                player = try AVAudioPlayer(contentsOf: trackURL)
                player?.delegate = self
                if let duration = player?.duration {
                    trackDuration = Float(duration)
                }
                player?.play()
            } catch {
                print("error")
            }
        }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        changePlayPauseIcon()
        
        labelTitle.text = "Impacto do conhecimento do produto no atendimento do pós-vendas"
        labelSubtitle.text = "Faixa \(currentSong+1)/\(totalOfSongs)"
        minimizeLabelTitle.text = "Ouvindo faixa \(currentSong+1)/\(totalOfSongs)"
        minimizeLabelSubtitle.text = "Faixa \(currentSong+1)/\(totalOfSongs)"
    }
    
    private func changePlayPauseIcon() {
        if player?.isPlaying ?? false {
            let image = UIImage.init(systemName: "pause.fill")
            buttonPlay.setImage(image, for: .normal)
            minimizeButtonPlay.setImage(image, for: .normal)
        } else {
            let image = UIImage.init(systemName: "play.fill")
            buttonPlay.setImage(image, for: .normal)
            minimizeButtonPlay.setImage(image, for: .normal)
        }
    }
    
    @objc
    private func updateSlider() {
        guard let currentTime = player?.currentTime else { return }
        slider.value = Float(currentTime)
    }
    
    // MARK: - Actions functions
    
    @IBAction
    private func buttonPlayPressed(_ sender: UIButton) {
        if player?.isPlaying ?? false {
            player?.pause()
        } else {
            player?.play()
        }
        changePlayPauseIcon()
    }
    
    @IBAction
    private func previousPressed(_ sender: UIButton) {
        if currentSong > 0 {
            currentSong -= 1
        }
        playTrack()
    }
    
    @IBAction
    private func nextPressed(_ sender: UIButton) {
        if currentSong < totalOfSongs-1 {
            currentSong += 1
        }
        playTrack()
    }
    
    @IBAction
    private func sliderChanged(_ sender: UISlider) {
        player?.stop()
        player?.currentTime = TimeInterval(sender.value)
        player?.prepareToPlay()
        player?.play()
    }
    
    @IBAction
    private func buttonClosePressed(_ sender: UIButton) {
        timer?.invalidate()
        viewModel.dismiss()
    }
    
    @IBAction
    private func buttonMinimizePressed(_ sender: UIButton) {
        audioView.isHidden = false
        fullScreenView.isHidden = true
        viewModel.minimize()
    }
    
    @IBAction
    private func buttonMaximizePressed(_ sender: UIButton) {
        viewModel.maximize()
        audioView.isHidden = true
        fullScreenView.isHidden = false
    }
    
    // MARK: - Public methods
    
    func updatePlayingTrack(to track: Int) {
        currentSong = track
        playTrack()
    }
    
}

extension PlayingTrackViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextPressed(UIButton())
    }
}
