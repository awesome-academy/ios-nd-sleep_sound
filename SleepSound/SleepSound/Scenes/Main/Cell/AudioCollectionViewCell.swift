//
//  AudioCollectionViewCell.swift
//  SleepSound
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

final class AudioCollectionViewCell: UICollectionViewCell, Reusable {
    
    @IBOutlet private weak var audioImageView: UIImageView!
    @IBOutlet private weak var audioNameLabel: UILabel!
    @IBOutlet private weak var volumeSlider: UISlider!
    @IBOutlet private weak var cellView: UIView!

    var sliderChanged: ((Float) -> Void)?
    let fillColor = UIColor(red: 180 / 255, green: 210 / 255, blue: 126 / 255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        sliderChanged?(sender.value)
    }
    
    func setContentForCell(text: String,
                           image: UIImage?,
                           isLocalImage: Bool,
                           isCheckRowSelected: Bool) {
        audioNameLabel.text = text
        if isLocalImage {
            audioImageView.kf.setImage(
                with: URL(string: "\(Urls.getAudioList)\(text).png".encoded()),
                placeholder: UIImage(named: "placeholderImage"),
                options: nil) { [weak self] result in
                    if let image = result.value?.image {
                        self?.audioImageView.image =
                            image.imageWithColor(newColor: isCheckRowSelected ? self?.fillColor : . white)
                    }
            }
        } else {
            audioImageView.image = image?.imageWithColor(newColor: isCheckRowSelected ? fillColor : .white)
        }
        
        if isCheckRowSelected {
            audioNameLabel.textColor = fillColor
            volumeSlider.isHidden = false
            cellView.layer.do {
                $0.borderColor = fillColor.cgColor
                $0.borderWidth = 1.0
                $0.cornerRadius = 10
            }
        } else {
            audioNameLabel.textColor = .white
            volumeSlider.isHidden = true
            cellView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
