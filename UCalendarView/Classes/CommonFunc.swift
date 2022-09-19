//
//  CommonFunc.swift
//  HealthDataLog (iOS)
//
//  Created by Tomohiro Uchida on 2022/06/10.
//

import Foundation
import SwiftUI

extension Date {
    
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        calendar.locale   = .current
        return calendar
    }
    
    func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, nanosecond: Int? = nil) -> Date {
        let calendar = self.calendar
        
        var comp = DateComponents()
        comp.year       = year       ?? calendar.component(.year,       from: self)
        comp.month      = month      ?? calendar.component(.month,      from: self)
        comp.day        = day        ?? calendar.component(.day,        from: self)
        comp.hour       = hour       ?? calendar.component(.hour,       from: self)
        comp.minute     = minute     ?? calendar.component(.minute,     from: self)
        comp.second     = second     ?? calendar.component(.second,     from: self)
        comp.nanosecond = nanosecond ?? calendar.component(.nanosecond, from: self)
        
        return calendar.date(from: comp)!
    }
    
    public func resetTime() -> Date {
        return self.fixed(hour:0, minute:0, second:0, nanosecond: 0)
    }
        
}

extension UIColor{
    public class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}

