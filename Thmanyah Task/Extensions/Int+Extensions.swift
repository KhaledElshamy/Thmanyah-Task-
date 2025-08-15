//
//  Int+Extensions.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

extension Int {
    var asHoursAndMinutes: String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        
        if hours > 0 {
            return "\(hours)hr \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
