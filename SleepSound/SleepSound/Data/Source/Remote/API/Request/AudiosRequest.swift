//
//  AudiosRequest.swift
//  SleepSound
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

final class AudiosRequest: BaseRequest {
    
    required init() {
        super.init(url: Urls.getAudioNameList, requestType: .get)
    }
}
