//
//  String+.swift
//  SleepSound
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

extension String {
    func encoded() -> String {
        let encoded = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encoded ?? ""
    }
}
