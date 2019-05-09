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
    private var arrAudioPlayer = [String: AVPlayer]()

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
        playPauseAudioButton.isSelected ? replay() : stopAudio()
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
        playPauseAudioButton.isSelected = arrAudioPlayer.isEmpty
        playPauseAudioButton.isEnabled = arrAudioPlayer.isEmpty
    }
    
    private func stopAudio() {
        for item in arrAudioPlayer.values {
            item.pause()
        }
    }
    
    private func replay() {
        for item in arrAudioPlayer.values {
            item.play()
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
        var isCheckLocalImage = false
        for item in arrAudioPlayer where item.key == audio {
            isCheckRowSelected = true
        }
        let image = UIImage(named: "\(audio).png")
        if indexPath.row >= Constants.arrAudioNameList.count {
            isCheckLocalImage = indexPath.row >= Constants.arrAudioNameList.count
        } else {
            isCheckLocalImage = indexPath.row >= Constants.arrAudioNameList.count
        }
        
        cell.setContentForCell(text: audio,
                               image: image,
                               isLocalImage: isCheckLocalImage,
                               isCheckRowSelected: isCheckRowSelected)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let audio = arrAudio[indexPath.row].name
        var player = AVPlayer()
        if indexPath.row >= Constants.arrAudioNameList.count {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            if let pathComponent = NSURL(fileURLWithPath: path).appendingPathComponent("\(audio).mp3") {
                if !FileManager.default.fileExists(atPath: pathComponent.path) {
                    showDefault(title: "Warning", message: "Audio is downloading, please wait for a while")
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
        
        if arrAudioPlayer.keys.contains(audio) {
            player.removePlayer()
            arrAudioPlayer.removeValue(forKey: audio)
        } else {
            if arrAudioPlayer.count > 10 {
                showDefault(title: "Warning", message: "Not select more than 10 audio")
                return
            } else {
                arrAudioPlayer.updateValue(player, forKey: audio)
            }
        }
        
        player.configure()
        player.play()
        reloadPlayButton()
        collectionView.reloadItems(at: [indexPath])
    }
}
// MARK: - StoryboardSceneBased
extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
