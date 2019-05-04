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
    
    // MARK: - Properties
    private let audioRepository = AudioRepositoryImpl(api: APIService.share)
    private var arrAudio = [Audio]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        fetchData()
    }
    
    deinit {
        logDeinit()
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
        let image = UIImage(named: "\(audio).png")
        if indexPath.row >= Constants.arrAudioNameList.count {
            cell.setContentForCell(text: audio,
                                   textColor: Constants.fillColor,
                                   image: image,
                                   isLocalImage: true)
        } else {
            cell.setContentForCell(text: audio,
                                   textColor: Constants.fillColor,
                                   image: image,
                                   isLocalImage: false)
        }
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
// MARK: - StoryboardSceneBased
extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

