//
//  Time.swift
//  Sport
//
//  Created by Anton Varenik on 4/9/21.
//  Copyright © 2021 Anton Varenik. All rights reserved.
//

import Foundation

class GetTime {
    public static func getCurrentTime() -> Time {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        return Time(hour: hour, minutes: minutes, second: second)
    }
}

struct Time {
    var hour: Int
    var minutes: Int
    var second: Int
}
