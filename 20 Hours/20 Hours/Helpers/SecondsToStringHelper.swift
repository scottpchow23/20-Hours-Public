//
//  SecondsToStringHelper.swift
//  20 Hours
//
//  Created by Scott Chow on 7/4/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import Foundation

class SecondsToStringHelper {
    
    static func toString(seconds: Double) -> String {
        var time = seconds
        let hours = Int(time/3600)
        time -= Double(hours*3600)
        
        let minutes = Int(time/60)
        time -= Double(minutes*60)
        
        let seconds = Int(time)
        time -= Double(seconds)
        
//        let fraction = Int(time*100)
        
        let stringHours = String(format: "%02d", hours)
        let stringMinutes = String(format: "%02d", minutes)
        let stringSeconds = String(format: "%02d", seconds)
//        let stringFraction = String(format: "%02d", fraction)
        
        return "\(stringHours):\(stringMinutes):\(stringSeconds)"
    }
}