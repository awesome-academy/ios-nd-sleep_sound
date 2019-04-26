//
//  AudioResponse.swift
//  SleepSound
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import ObjectMapper

final class AudiosResponse: Mappable {
    
    var totalCount: Int?
    var audios = [Audio]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        totalCount <- map["total_count"]
        audios <- map["items"]
    }
}
