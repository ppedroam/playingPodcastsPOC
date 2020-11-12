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
    
    private var isMinimized = false {
        didSet {
            audioView.isHidden = !isMinimized
            fullScreenView.isHidden = isMinimized
        }
    }
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
    
    deinit {
        print("VIEWCONTROLLER DEINIT")
        print("VIEWCONTROLLER DEINIT")
    }
    
    // MARK: - Lyfe cicle

    override func viewDidLoad() {
        super.viewDidLoad()
        playTrack()
        configureUI()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player = nil
        self.timer = nil
        print("VIEWCONTROLLER DISAPPEAR")
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
    
    private func playTrack() {
        timer?.invalidate()
        if player != nil {
            guard let trackURL = viewModel.track(for: currentSong) else {
                return
            }
            player = try? AVAudioPlayer(contentsOf: trackURL)
            if let duration = player?.duration {
                trackDuration = Float(duration)
            }
            player?.prepareToPlay()
            player?.play()
        } else {
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

                guard let trackURL = viewModel.track(for: currentSong) else {
                    return
                }
                player = try AVAudioPlayer(contentsOf: trackURL)
                if let duration = player?.duration {
                    trackDuration = Float(duration)
                }
                player?.prepareToPlay()
                player?.play()
            } catch {
                print("error")
            }
        }
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
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
    
    private func nextTrack() {
        if currentSong < totalOfSongs-1 {
            currentSong += 1
            playTrack()
        } else {
            player?.stop()
            changePlayPauseIcon()
        }
    }
    
    @objc
    private func updateSlider() {
        guard let currentTime = player?.currentTime else { return }
        slider.value = Float(currentTime)
        if slider.value > 0.99*slider.maximumValue {
            nextTrack()
        }
    }
    
    @objc
    private func handleDismiss(sender: UIPanGestureRecognizer) {
        guard !isMinimized else { return }
        viewTranslation = sender.translation(in: view)
        
        switch sender.state {
        case .changed:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                    self.view.transform = .identity
                })
            } else {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                    self.view.transform = .identity
                    self.viewModel.minimize()
                    self.isMinimized = true
                })
                
            }
        default:
            break
        }
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
        nextTrack()
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
        isMinimized = true
        viewModel.minimize()
    }
    
    @IBAction
    private func buttonMaximizePressed(_ sender: UIButton) {
        isMinimized = false
        viewModel.maximize()
    }
    
    // MARK: - Public methods
    
    func updatePlayingTrack(to track: Int) {
        currentSong = track
        playTrack()
    }
    
}
