//
//  UserDefaults+.swift
//  SleepSound
//
//  Created by mac on 5/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

extension UserDefaults {
    func dateForKey(_ string: String) -> Date? {
        return object(forKey: string) as? Date
    }
    
    func setDate(_ date: Date, forKey: String) {
        set(date, forKey: forKey)
    }
}
