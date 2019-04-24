//
//  AudioCollectionViewCell.swift
//  SleepSound
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

final class AudioCollectionViewCell: UICollectionViewCell, Reusable{
    
    @IBOutlet private weak var imageAudio: UIImageView!
    @IBOutlet private weak var lbNameAudio: UILabel!
    @IBOutlet private weak var sliderVolumeAudio: UISlider!
    
    var sliderChanged = { (value: Float) -> Void in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        sliderChanged(sender.value)
    }
    
    func config(text: String, textColor: UIColor, image: UIImage) {
        lbNameAudio.text = text
        lbNameAudio.textColor = textColor
        imageAudio.image = image.imageWithColor(newColor: Constant.kColorSelected)
    }
}
