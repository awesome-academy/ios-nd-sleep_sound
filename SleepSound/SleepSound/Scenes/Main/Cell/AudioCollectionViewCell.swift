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
    @IBOutlet weak var cellView: UIView!

    var sliderChanged: ((Float) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        sliderChanged?(sender.value)
    }
    
    func setContentForCell(text: String, textColor: UIColor, image: UIImage?, isLocalImage: Bool) {
        audioNameLabel.text = text
        audioNameLabel.textColor = Constants.fillColor
        if isLocalImage {
            audioImageView.kf.setImage(
                with: URL(string: "\(Urls.getAudioList)\(text).png".encoded()),
                placeholder: UIImage(named: "placeholderImage"),
                options: nil) { [weak self] result in
                    if let image = result.value?.image {
                        self?.audioImageView.image = image.imageWithColor(newColor: Constants.fillColor)
                    }
            }
        } else {
            audioImageView.image = image?.imageWithColor(newColor: Constants.fillColor)
        }
    }
}
