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
    
    func setContentForCell(text: String, textColor: UIColor, image: UIImage?, isLocalImage: Bool, isCheckRowSelected: Bool) {
        audioNameLabel.text = text
        audioNameLabel.textColor = fillColor
        if isCheckRowSelected {
            if isLocalImage {
                audioImageView.kf.setImage(
                    with: URL(string: "\(Urls.getAudioList)\(text).png".encoded()),
                    placeholder: UIImage(named: "placeholderImage"),
                    options: nil) { [weak self] result in
                        if let image = result.value?.image {
                            self?.audioImageView.image = image.imageWithColor(newColor: self?.fillColor)
                        }
                }
            } else {
                audioImageView.image = image?.imageWithColor(newColor: fillColor)
            }
            audioNameLabel.textColor = Constants.fillColor
            volumeSlider.isHidden = false
            cellView.layer.borderColor = Constants.fillColor.cgColor
            cellView.layer.borderWidth = 1.0
            cellView.layer.cornerRadius = 10
        } else {
            if isLocalImage {
                audioImageView.kf.setImage(
                    with: URL(string: "\(Urls.getAudioList)\(text).png".encoded()),
                    placeholder: UIImage(named: "placeholderImage"),
                    options: nil) { result in
                        if let _image = result.value?.image {
                            self.audioImageView.image = _image.imageWithColor(newColor: UIColor.white)
                        }
                }
            } else {
                audioImageView.image = image?.imageWithColor(newColor: UIColor.white)
            }
            audioNameLabel.textColor = UIColor.white
            volumeSlider.isHidden = true
            cellView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
