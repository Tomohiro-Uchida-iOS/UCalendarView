import Foundation
import SwiftUI

public class UCEntry {
    var date: Date = Date().resetTime()
    var leftLabel: String = ""
    var leftLabelColor: UIColor = UIColor.black
    var middleLabel: String = ""
    var middleLabelColor: UIColor = UIColor.black
    var value: Double = 0.0
    var valueColor: UIColor = UIColor.black
    var unit: String = ""
    var unitColor: UIColor = UIColor.black
    var rightLabel: String = ""
    var rightLabelColor: UIColor = UIColor.black
    
    public init() {}
    
}

public enum UCDayType {
    case weekday
    case sunday
    case saturday
    case holiday
}

public class UCDay {
    var date: Date = Date().resetTime()
    var dayType: UCDayType = .weekday
    var entries: [UCEntry] = []

    public init() {}

}

public class UCWeek {
    var days: [UCDay] = Array(repeating: UCDay(), count: 7)

    public init() {}

}

public class UCMonth {
    var month: Date = Date().resetTime()
    var weeks: [UCWeek] = Array(repeating: UCWeek(), count: 6)

    public init() {}

}


public struct UCalendarView: View {

    @State var entries: [UCEntry] = []

    public init(entries: [UCEntry]) {
        self.entries = entries
    }
    
    public var body: some View {
        Text("Hello World!!")
    }
}
