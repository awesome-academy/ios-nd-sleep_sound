//
//  BaseResult.swift
//  SleepSound
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

enum BaseResult<T: Mappable> {
    case success(T?)
    case failure(error: BaseError?)
}
