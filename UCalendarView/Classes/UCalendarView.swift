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
    var value: String = ""
    var valueColor: Color = Color.black
    var unit: String = ""
    var unitColor: Color = Color.black
    var rightLabel: String = ""
    var rightLabelColor: Color = Color.black
    var tableFontSize: CGFloat = 8.0
    
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
        // self.ucEntryViewType = ucEntryViewType
        // self.ucEntry = ucEntry
        _ucEntryViewType = State(initialValue: ucEntryViewType)
        _ucEntry = State(initialValue: ucEntry)
    }
    
    public var body: some View {
        if self.ucEntryViewType == .table {
            Text(ucEntry.value)
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
    @State var ucDay: UCDay
    @State var ucDayType: UCDayViewType = .weekday
    @State var displayMaxEntries: Int = 0

    public init(
        ucDay: UCDay
    ) {
        // self.ucDay = ucDay
        _ucDay = State(initialValue: ucDay)
    }
    
    public var body: some View {
        VStack {
            let calendar = Calendar(identifier: .gregorian)
            HStack {
                switch self.ucDayType {
                case .sunday:
                    Text(String(format: "%d", calendar.component(.day, from: self.ucDay.date.resetTime())))
                        .foregroundColor(Color.red)
                case .saturday:
                    Text(String(format: "%d", calendar.component(.day, from: self.ucDay.date.resetTime())))
                        .foregroundColor(Color.blue)
                default:
                    Text(String(format: "%d", calendar.component(.day, from: self.ucDay.date.resetTime())))
                        .foregroundColor(Color.black)
                }
                Spacer()
            }
            ForEach (0..<self.displayMaxEntries, id: \.self) { index in
                UCEntryView(
                    ucEntryViewType: .table,
                    ucEntry: ucDay.ucEntries[index]
                )
            }
            ForEach (0..<(3-self.displayMaxEntries), id: \.self) { _ in
                Text("")
            }
        }
        .onAppear() {
            if ucDay.ucEntries.count >= 3 {
                self.displayMaxEntries = 3
            } else {
                self.displayMaxEntries = ucDay.ucEntries.count
            }
            let calendar = Calendar(identifier: .gregorian)
            switch calendar.component(.weekday, from: self.ucDay.date.resetTime()) {
            case 0:
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
        weekOfMonth: Int,
        ucDays: [UCDay]
    ) {
        let calendar = Calendar(identifier: .gregorian)
        self.weekOfMonth = weekOfMonth
        ucDays.forEach{ day in
            if calendar.component(.weekOfMonth, from: day.date.resetTime()) == self.weekOfMonth {
                self.ucDays.append(day)
            }
        }
    }
}

private struct UCWeekView: View {
    @State var ucWeek: UCWeek

    public init(
        ucWeek: UCWeek
    ) {
        // self.ucWeek = ucWeek
        _ucWeek = State(initialValue: ucWeek)
    }

    public var body: some View {
        HStack {
            ForEach (self.ucWeek.ucDays, id: \.uuid) { ucDay in
                UCDayView(
                    ucDay: ucDay
                )
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
    @Binding var ucMonth: UCMonth

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
    @State var ucEntries: [UCEntry] = []
    @State private var ucMonth: UCMonth = UCMonth(month: Date().resetTime(), ucWeeks: [])
    @State private var ucWeeks: [UCWeek] = []
    @State private var ucDays: [UCDay] = []
    @ObservedObject private var obsObject = ObserveModel()

    public init(
        month: Date,
        ucEntries: [UCEntry]
    ) {
        self.month = month.resetTime()
        self.ucEntries = ucEntries
    }

    public var body: some View {
        UCMonthView(ucMonth: self.$ucMonth)
        .onAppear() {
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
        }
    }
}
