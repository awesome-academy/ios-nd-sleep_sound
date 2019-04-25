//
//  FavouriteViewController.swift
//  SleepSound
//
//  Created by mac on 4/25/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

final class FavouriteViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - StoryboardSceneBased
extension FavouriteViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
