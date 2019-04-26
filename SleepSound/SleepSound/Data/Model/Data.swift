//
//  Data.swift
//  SleepSound
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import ObjectMapper

struct Data {
    var audios: [Audio] = []
    var code = 0
}

extension Data: Mappable {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        audios <- map["data"]
        code <- map["code"]
    }
}
