//
//  MainViewController.swift
//  SleepSound
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var audioSearchBar: UISearchBar!
    @IBOutlet private weak var mixerButton: UIButton!
    @IBOutlet private weak var audioCollectionView: UICollectionView!
    @IBOutlet private weak var playPauseAudioButton: UIButton!
    
    // MARK: - Properties
    private var arrAudio = [Audio]()
    private let audioRepository = AudioRepositoryImpl(api: APIService.share)
    private var arrAudioPlayer = [(name: String, player: AVPlayer)]()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        fetchData()
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - IBAction
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        playPauseAudioButton.isSelected = !playPauseAudioButton.isSelected
        if playPauseAudioButton.isSelected {
            self.replay()
        } else {
            self.stopAudio()
        }
    }
    
    // MARK: - Methods
    
    private func configView() {
        mixerButton.setImage(UIImage(named: "mixer.png")?
            .imageWithColor(newColor: Constants.fillColor), for: .normal)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func fetchData() {
        audioRepository.fetchAudio { result in
            switch result {
            case .success(let response):
                guard let audios = response?.audios else { return }
                var urls: [String] = []
                audios.forEach {
                    urls.append(String(format: "%@/%@.mp3", Urls.getAudioList, $0.name))
                }
                DownloadService.share.downloadUrls(urls: urls,
                                                   start: { [weak self] in
                                                    self?.displayStartDownloadAlert() },
                                                   startDownload: {[weak self] text in
                                                    self?.displayStartDownloadAlert(url: text)
                                                    },
                                                   completion: { [weak self] in
                                                    self?.displayFinishDownloadAlert() })
                self.arrAudio = Constants.arrAudioNameList
                for item in audios {
                    self.arrAudio.append(item)
                }
                self.audioCollectionView.reloadData()
            case .failure(let error):
                self.showError(message: error?.errorMessage)
            }
        }
    }
    
    func reloadPlayButton() {
        if !arrAudioPlayer.isEmpty {
            playPauseAudioButton.isSelected = true
            playPauseAudioButton.isEnabled = true
        } else {
            playPauseAudioButton.isSelected = false
            playPauseAudioButton.isEnabled = false
        }
    }
    
    func stopAudio() {
        for item in arrAudioPlayer {
            item.player.pause()
        }
    }
    
    func replay() {
        for item in arrAudioPlayer {
            item.player.play()
        }
    }
    
    func displayStartDownloadAlert() {
        DispatchQueue.main.async {
            UIApplication.topViewController()?.view.makeToast("Start Download")
        }
    }
    
    func displayStartDownloadAlert(url: String) {
        if let range = url.range(of: "\(Urls.getAudioList)") {
            let name = url[range.upperBound...]
            DispatchQueue.main.async {
                UIApplication.topViewController()?.view.makeToast("\(name) is downloading")
            }
        }
    }
    
    func displayFinishDownloadAlert() {
        DispatchQueue.main.async {
            UIApplication.topViewController()?.view.makeToast("Download Successful")
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 3
        return CGSize(width: width, height: width)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAudio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AudioCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let audio = arrAudio[indexPath.row].name
        
        var isCheckRowSelected = false
        for item in arrAudioPlayer where item.name == audio {
            isCheckRowSelected = true
        }
        
        let image = UIImage(named: "\(audio).png")
        if indexPath.row >= Constants.arrAudioNameList.count {
            cell.setContentForCell(text: audio,
                                   textColor: Constants.fillColor,
                                   image: image,
                                   isLocalImage: true,
                                   isCheckRowSelected: isCheckRowSelected)
        } else {
            cell.setContentForCell(text: audio,
                                   textColor: Constants.fillColor,
                                   image: image,
                                   isLocalImage: false,
                                   isCheckRowSelected: isCheckRowSelected)
        }
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let audio = arrAudio[indexPath.row].name
        var idx = 0
        var player = AVPlayer()
        
        for item in arrAudioPlayer {
            if item.name == audio {
                // remove this audio
                item.player.pause()
                arrAudioPlayer.remove(at: idx)
                collectionView.reloadData()
                reloadPlayButton()
                return
            }
            idx += 1
        }
        
        if indexPath.row >= Constants.arrAudioNameList.count {
            // check audio file in document
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent("\(audio).mp3") {
                let fileManager = FileManager.default
                if !fileManager.fileExists(atPath: pathComponent.path) {
                    UIAlertController.showDefault(title: "Warning",
                                                  message: "Audio is downloading, please wait for a while")
                    return
                } else {
                    player = AVPlayer(url: pathComponent.absoluteURL)
                }
            }
        } else {
            let audioName = Bundle.main.path(forResource: audio, ofType: "mp3")
            let audioURL = URL(fileURLWithPath: audioName ?? "")
            player = AVPlayer(url: audioURL)
        }
        
        player.configure()
        player.play()
        arrAudioPlayer.append((name: audio, player: player))
        reloadPlayButton()
        collectionView.reloadData()
    }
}
// MARK: - StoryboardSceneBased
extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

