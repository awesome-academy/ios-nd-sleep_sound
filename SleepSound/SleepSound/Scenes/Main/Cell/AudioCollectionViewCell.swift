//
//  AudioCollectionViewCell.swift
//  SleepSound
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

final class AudioCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageAudio: UIImageView!
    @IBOutlet weak var lbNameAudio: UILabel!
    @IBOutlet weak var sliderVolumeAudio: UISlider!
    
    var sliderChanged = { (value: Float) -> Void in
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        self.sliderChanged(sender.value)
    }}
