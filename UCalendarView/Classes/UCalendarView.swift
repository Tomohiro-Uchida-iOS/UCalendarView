import Foundation
import SwiftUI

private enum UCEntryViewType {
    case table
    case list
}

public class UCEntry {
    var uuid = UUID()
    var date: Date = Date().resetTime()
    var leftLabel: String = ""
    var leftLabelColor: Color = Color.black
    var middleLabel: String = ""
    var middleLabelColor: Color = Color.black
    var value: String = " "  // Space, not empty String
    var valueColor: Color = Color.black
    var unit: String = ""
    var unitColor: Color = Color.black
    var rightLabel: String = ""
    var rightLabelColor: Color = Color.black
    var tableFontSize: CGFloat = 8.0
    
    public init() {}
    
    public init(
        date: Date,
        leftLabel: String,
        leftLabelColor: Color,
        middleLabel: String,
        middleLabelColor: Color,
        value: String,
        valueColor: Color,
        unit: String,
        unitColor: Color,
        rightLabel: String,
        rightLabelColor: Color,
        tableFontSize: CGFloat
    ) {
        self.date = date
        self.leftLabel = leftLabel
        self.leftLabelColor = leftLabelColor
        self.middleLabel = middleLabel
        self.middleLabelColor = middleLabelColor
        self.value = value
        self.valueColor = valueColor
        self.unit = unit
        self.unitColor = unitColor
        self.rightLabel = rightLabel
        self.rightLabelColor = Color.black
        self.tableFontSize = tableFontSize
    }
    
}

private struct UCEntryView: View {
    @State var ucEntryViewType: UCEntryViewType = .table
    @State var ucEntry: UCEntry
        
    public init(
        ucEntryViewType: UCEntryViewType,
        ucEntry: UCEntry
    ) {
        _ucEntryViewType = State(initialValue: ucEntryViewType)
        _ucEntry = State(initialValue: ucEntry)
    }
    
    public var body: some View {
        if self.ucEntryViewType == .table {
            Text(ucEntry.value)
                .foregroundColor(ucEntry.valueColor)
                .frame(alignment: .trailing)
                .font(.system(size: ucEntry.tableFontSize))
        } else {
            Text(ucEntry.leftLabel)
                .foregroundColor(ucEntry.leftLabelColor)
            Spacer()
            Text(ucEntry.middleLabel)
                .foregroundColor(ucEntry.middleLabelColor)
            Spacer()
            Text(ucEntry.value)
                .foregroundColor(ucEntry.valueColor)
                .frame(alignment: .trailing)
            Text(ucEntry.unit)
                .foregroundColor(ucEntry.unitColor)
                .frame(alignment: .leading)
            Text(ucEntry.rightLabel)
                .foregroundColor(ucEntry.rightLabelColor)
        }
    }
}

private enum UCDayViewType {
    case weekday
    case sunday
    case saturday
    case holiday
}

private class UCDay {
    var uuid = UUID()
    var date: Date
    var ucEntries: [UCEntry] = []
    
    public init(
        date: Date,
        ucEntries: [UCEntry]
    ) {
        self.date = date
        self.ucEntries = ucEntries.filter {
            $0.date == self.date
        }
    }
}

private struct UCDayView: View {
    private var ucDay: UCDay
    @State var ucDayType: UCDayViewType = .weekday
    @State var displayMaxEntries: Int = 0

    public init(
        ucDay: UCDay
    ) {
        self.ucDay = ucDay
    }
    
    public var body: some View {
        VStack {
            let calendar = Calendar(identifier: .gregorian)
            HStack {
                switch self.ucDayType {
                case .sunday:
                    Text(String(format: "%d", calendar.component(.day, from: self.ucDay.date.resetTime())))
                        .foregroundColor(Color.red)
                        .font(.system(size: 11))
                case .saturday:
                    Text(String(format: "%d", calendar.component(.day, from: self.ucDay.date.resetTime())))
                        .foregroundColor(Color.blue)
                        .font(.system(size: 11))
                default:
                    Text(String(format: "%d", calendar.component(.day, from: self.ucDay.date.resetTime())))
                        .foregroundColor(Color.black)
                        .font(.system(size: 11))
                }
                Spacer()
            }
            ForEach (0..<self.displayMaxEntries, id: \.self) { index in
                UCEntryView(
                    ucEntryViewType: .table,
                    ucEntry: self.ucDay.ucEntries[index]
                )
            }
            ForEach (0..<(3-self.displayMaxEntries), id: \.self) { _ in
                UCEntryView(
                    ucEntryViewType: .table,
                    ucEntry: UCEntry()
                )
            }
        }
        .onAppear() {
            if self.ucDay.ucEntries.count >= 3 {
                self.displayMaxEntries = 3
            } else {
                self.displayMaxEntries = ucDay.ucEntries.count
            }
            let calendar = Calendar(identifier: .gregorian)
            switch calendar.component(.weekday, from: self.ucDay.date.resetTime()) {
            case 1:
                self.ucDayType = .sunday
                break
            case 7:
                self.ucDayType = .saturday
                break
            default:
                self.ucDayType = .weekday
            }
        }
    }
}


private class UCWeek {
    var uuid = UUID()
    var weekOfMonth: Int
    var ucDays: [UCDay] = []
    
    public init(
        thisMonth: Int,
        weekOfMonth: Int,
        ucDays: [UCDay]
    ) {
        self.weekOfMonth = weekOfMonth
        ucDays.forEach{ day in
            let weekOfMonth = getWeekOfMonth(thisMonth: thisMonth, day: day.date)
            if weekOfMonth == self.weekOfMonth {
                self.ucDays.append(day)
            }
        }
    }

    func getWeekOfMonth(
        thisMonth: Int,
        day: Date
    ) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let monthOfDay = calendar.component(.month, from: day)
        if monthOfDay < thisMonth {
            return 1
        } else if thisMonth < monthOfDay {
            let minus = DateComponents(month: -1)
            let previousMonth = calendar.date(byAdding: minus, to: day)!
            var day1st = DateComponents()
            day1st.year = calendar.component(.year, from: previousMonth)
            day1st.month = calendar.component(.month, from: previousMonth)
            day1st.day = 1
            let firstDay = calendar.date(from: day1st)!
            let add = DateComponents(month: 1, day: -1) // 月初から1ヶ月進めて1日戻す
            let lastDay = calendar.date(byAdding: add, to: firstDay)!
            let weekOfLastDay = calendar.component(.weekOfMonth, from: lastDay)
            let weekOfDay = calendar.component(.weekOfMonth, from: day)
            return weekOfLastDay + weekOfDay - 1
        } else {
            return calendar.component(.weekOfMonth, from: day)
        }
    }

}

private struct UCWeekView: View {
    private var ucWeek: UCWeek

    public init(
        ucWeek: UCWeek
    ) {
        self.ucWeek = ucWeek
    }

    public var body: some View {
        HStack {
            ForEach (self.ucWeek.ucDays, id: \.uuid) { ucDay in
                UCDayView(
                    ucDay: ucDay                )
            }
        }
    }
}


private class UCMonth {
    var month: Date
    var ucWeeks: [UCWeek] = []
    
    public init(
        month: Date,
        ucWeeks: [UCWeek]
    ) {
        self.month = month.resetTime()
        self.ucWeeks = ucWeeks
    }
}

private struct UCMonthView: View {
    private var ucMonth: UCMonth
    
    init(
        ucMonth: UCMonth
    ) {
        self.ucMonth = ucMonth
    }

    public var body: some View {
        VStack {
            ForEach (self.ucMonth.ucWeeks, id: \.uuid) { ucWeek in
                UCWeekView(
                    ucWeek: ucWeek
                )
            }
        }
    }
}

private func startDateInMonth(
    month: Date
) ->  Date {
    let calendar = Calendar(identifier: .gregorian)
    var startDate = calendar.date(
        from: DateComponents(
            year: calendar.component(.year, from: month.resetTime()),
            month: calendar.component(.month, from: month.resetTime()),
            day: 1
        )
    )!.resetTime()
    startDate = calendar.date(
        byAdding: .day,
        value: -(calendar.component(.weekday, from: startDate.resetTime())-1),
        to: startDate.resetTime())!.resetTime()
    return startDate.resetTime()
}

private func endDateInMonth(
    month: Date
) ->  Date {
    let calendar = Calendar(identifier: .gregorian)
    let startDate = startDateInMonth(month: month).resetTime()
    var endDate = calendar.date(
        byAdding: .day,
        value: calendar.component(.day, from: startDate.resetTime())-1,
        to: startDate
    )!.resetTime()
    endDate = calendar.date(
        byAdding: .day,
        value: 7-calendar.component(.weekday, from: endDate.resetTime()),
        to: endDate)!
    return endDate
}

private func ucEntriesInMonth(
    month: Date,
    inUcEntries: [UCEntry]
) -> [UCEntry] {
    let outUcEntries =  inUcEntries.filter{ startDateInMonth(month: month) <= $0.date && $0.date <= endDateInMonth(month: month) }
    return outUcEntries
}

public struct UCalendarView: View {

    @State var month: Date = Date().resetTime()
    @Binding var ucEntries: [UCEntry]
    private var ucMonth: UCMonth = UCMonth(month: Date().resetTime(), ucWeeks: [])
    private var ucWeeks: [UCWeek] = []
    private var ucDays: [UCDay] = []
    @ObservedObject private var obsObject = ObserveModel()

    public init(
        month: Date,
        ucEntries: [UCEntry]
    ) {
        // self.month = month.resetTime()
        // self.ucEntries = ucEntries
        
        _month = State(initialValue: month.resetTime())
        self._ucEntries = Binding {return ucEntries} set: { newValue in
        }
        
        let calendar = Calendar(identifier: .gregorian)
        var pointedDate = startDateInMonth(month: month.resetTime())
        for _ in 1...42 {
            let ucDay = UCDay(date: pointedDate, ucEntries: self.ucEntries)
            self.ucDays.append(ucDay)
            pointedDate = calendar.date(byAdding: .day, value: 1, to: pointedDate.resetTime())!
        }
        for week in 1...6 {
            let ucWeek = UCWeek(
                thisMonth: calendar.component(.month, from: month),
                weekOfMonth:week,
                ucDays: self.ucDays
            )
            self.ucWeeks.append(ucWeek)
        }
        self.ucMonth = UCMonth(month: self.month, ucWeeks: self.ucWeeks)
        obsObject.count += 1

    }

    public var body: some View {
        UCMonthView(ucMonth: self.ucMonth)
        .onAppear() {
            /*
            let calendar = Calendar(identifier: .gregorian)
            var components = DateComponents()
            components.year = calendar.component(.year, from: self.month)
            // 日数を求めたい次の月。13になってもOK。ドキュメントにも、月もしくは月数とある
            components.month = calendar.component(.month, from: self.month)+1
            // 日数を0にすることで、前の月の最後の日になる
            components.day = 0
            // 求めたい月の最後の日のDateオブジェクトを得る
            let date = calendar.date(from: components)!.resetTime()
            let dayCount = calendar.component(.day, from: date)
            components.year = calendar.component(.year, from: self.month)
            components.month = calendar.component(.month, from: self.month)
            for day in 1...dayCount {
                // 日数を0にすることで、前の月の最後の日になる
                components.day = day
                let ucDay = UCDay(date: calendar.date(from: components)!, ucEntries: self.ucEntries)
                self.ucDays.append(ucDay)
            }
            for week in 1...6 {
                let ucWeek = UCWeek(weekOfMonth: week, ucDays: self.ucDays)
                self.ucWeeks.append(ucWeek)
            }
            self.ucMonth = UCMonth(month: self.month, ucWeeks: self.ucWeeks)
            obsObject.count += 1
             */
        }
    }
}
