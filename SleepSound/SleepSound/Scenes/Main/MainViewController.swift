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
    @IBOutlet private weak var randomButton: UIButton!
    @IBOutlet private weak var playPauseAudioButton: UIButton!
    @IBOutlet private weak var audioCollectionView: UICollectionView!
    
    // MARK: - Properties
    private var arrAudio = [Audio]()
    private var filteredAudio = [Audio]()
    private var searchingAudio = false
    private let audioRepository = AudioRepositoryImpl(api: APIService.share)
    private var arrAudioPlayer = [String: AVPlayer]()
    private var timerRandom: Timer! = nil

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        fetchData()
        audioSearchBar.delegate = self
    }

    deinit {
        logDeinit()
    }
    
    // MARK: - IBAction
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        playPauseAudioButton.isSelected = !playPauseAudioButton.isSelected
        playPauseAudioButton.isSelected ? replay() : stopAudio()
    }
    
    @IBAction func randomButtonTapped(_ sender: Any) {
        arrAudioPlayer.removeAll()
        randomButton.isSelected = !randomButton.isSelected
        randomButton.isSelected ? startTimerRandom() : stopTimerRandom()
        reloadPlayButton()
        playPauseAudioButton.isSelected = randomButton.isSelected
        audioCollectionView.reloadData()
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
        playPauseAudioButton.isSelected = !arrAudioPlayer.isEmpty
        playPauseAudioButton.isEnabled = !arrAudioPlayer.isEmpty
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
    
    func stopTimerRandom() {
        if timerRandom != nil {
            timerRandom.invalidate()
            timerRandom = nil
        }
    }
    
    func startTimerRandom() {
        let indexPathRow = Int(arc4random_uniform(UInt32(arrAudio.count)))
        let audio = arrAudio[indexPathRow].name
        arrAudioPlayer.updateValue(playerForName(indexPathRow), forKey: audio)
        reloadPlayButton()
        audioCollectionView.reloadData()
    }
    
    func playerForName(_ row: Int) -> AVPlayer {
        var player = AVPlayer()
        if row >= Constants.arrAudioNameList.count {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            if let pathComponent = NSURL(fileURLWithPath: path).appendingPathComponent("\(arrAudio[row].name).mp3") {
                if !FileManager.default.fileExists(atPath: pathComponent.path) {
                    showDefault(title: "Warning", message: "Audio is downloading, please wait for a while")
                    randomButton.isSelected = false
                    return player
                } else {
                    player = AVPlayer(url: pathComponent.absoluteURL)
                }
            }
        } else {
            let audioName = Bundle.main.path(forResource: arrAudio[row].name, ofType: "mp3")
            let audioURL = URL(fileURLWithPath: audioName ?? "")
            player = AVPlayer(url: audioURL)
        }
        player.configure()
        player.play()
        return player
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
        return searchingAudio ? filteredAudio.count : arrAudio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AudioCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let audio = searchingAudio ? filteredAudio[indexPath.row].name : arrAudio[indexPath.row].name
        
        var isCheckRowSelected = false
        var isCheckLocalImage = false
        for item in arrAudioPlayer where item.key == audio {
            isCheckRowSelected = true
        }
        let image = UIImage(named: "\(audio).png")
        if image != nil {
            isCheckLocalImage = false
        } else {
            isCheckLocalImage = true
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
        if arrAudioPlayer.keys.contains(audio) {
            arrAudioPlayer.removeValue(forKey: audio)
        } else {
            if arrAudioPlayer.count > 10 {
                showDefault(title: "Warning", message: "Not select more than 10 audio")
                return
            } else {
                arrAudioPlayer.updateValue(playerForName(indexPath.row), forKey: audio)
            }
        }
        reloadPlayButton()
        collectionView.reloadItems(at: [indexPath])
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else {
            return
        }
        filteredAudio = searchText.isEmpty ? arrAudio : arrAudio.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
        searchingAudio = true
        audioCollectionView.reloadData()
    }
}

// MARK: - StoryboardSceneBased
extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
