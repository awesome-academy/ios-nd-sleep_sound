//
//  ErrorResponse.swift
//  SleepSound
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import ObjectMapper

final class ErrorResponse: Mappable {
    var documentationUrl: String?
    var message: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        documentationUrl <- map["documentation_url"]
        message <- map["message"]
    }
}
