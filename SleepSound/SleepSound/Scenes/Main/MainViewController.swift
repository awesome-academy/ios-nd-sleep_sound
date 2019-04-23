//
//  MainViewController.swift
//  SleepSound
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

final class MainViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnMixer: UIButton!
    @IBOutlet weak var collectionViewListAudio: UICollectionView!
    
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
    
    private func configView() {
        navigationController?.navigationBar.isHidden = true
        btnMixer.setImage(UIImage(named: "mixer.png")?.imageWithColor(newColor: kSelectedColor), for: .normal)
    }

}

// MARK: - StoryboardSceneBased
extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30 ) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrNameAudio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioCollectionViewCell",
                                                      for: indexPath) as? AudioCollectionViewCell
        if let cell = cell {
            let audio = arrNameAudio[indexPath.row]
            cell.lbNameAudio.text = audio
            let image = UIImage(named: "\(audio).png")
            cell.imageAudio.image = image?.imageWithColor(newColor: kSelectedColor)
            cell.lbNameAudio.textColor = kSelectedColor
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
