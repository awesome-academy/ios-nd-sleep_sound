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
    
    var sliderChanged: ((Float) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        sliderChanged?(sender.value)
    }
    
    func setContentForCell(text: String, textColor: UIColor, image: UIImage) {
        audioNameLabel.text = text
        audioNameLabel.textColor = textColor
        audioImageView.image = image.imageWithColor(newColor: Constants.fillColor)
    }
}
