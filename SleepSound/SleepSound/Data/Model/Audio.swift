//
//  Audio.swift
//  SleepSound
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import ObjectMapper

struct Audio {
    var name: String
}

extension Audio {
    init() {
        self.init(name: "")
    }
}

extension Audio: Mappable {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
    }
}
