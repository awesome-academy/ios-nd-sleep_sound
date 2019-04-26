//
//  AudiosRequest.swift
//  SleepSound
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

final class AudiosRequest: BaseRequest {
    
    required init(page: Int, perPage: Int = 10) {
        let parameters: [String: Any]  = [
            "q": "language:swift",
            "per_page": perPage,
            "page": page
        ]
        super.init(url: Urls.getAudioNameList, requestType: .get, parameters: parameters)
    }
}
