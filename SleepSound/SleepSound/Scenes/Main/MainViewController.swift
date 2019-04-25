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
    @IBOutlet private weak var playAudioButton: UIButton!
    @IBOutlet private weak var audioCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    @IBAction func playAudioButtonTapped(_ sender: Any) {
        playAudioButton.isSelected = !playAudioButton.isSelected
    }
    
    @IBAction func randomButtonTapped(_ sender: Any) {
    }
    
    private func configView() {
        mixerButton.setImage(UIImage(named: "mixer.png")?
            .imageWithColor(newColor: Constants.fillColor), for: .normal)
        navigationController?.isNavigationBarHidden = true
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
        return Constants.arrAudioNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AudioCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let audio = Constants.arrAudioNameList[indexPath.row]
        if let image = UIImage(named: "\(audio).png") {
            cell.setContentForCell(text: audio, textColor: Constants.fillColor, image: image)
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

