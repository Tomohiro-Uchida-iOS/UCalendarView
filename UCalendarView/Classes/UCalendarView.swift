import Foundation
import SwiftUI

class ObserveModel: ObservableObject{
    @Published var count = 0
}

public class EntryList: ObservableObject {
    @Published var entryList: [UCEntryView] = []
    
    public init() {}
}

enum UCEntryViewType {
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
    var tableFontSize: CGFloat = 10.0
    var listFontSize: CGFloat = 12.0

    static func == (lhs: UCEntry, rhs: UCEntry) -> Bool {
        return lhs.date == rhs.date &&
        lhs.leftLabel == rhs.leftLabel &&
        lhs.middleLabel == rhs.middleLabel &&
        lhs.value == rhs.value &&
        lhs.unit == rhs.unit &&
        lhs.rightLabel == rhs.rightLabel
    }
    
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
        tableFontSize: CGFloat,
        listFontSize: CGFloat
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
        self.rightLabelColor = rightLabelColor
        self.tableFontSize = tableFontSize
        self.listFontSize = listFontSize
    }
    
}

struct UCEntryView: View, Equatable {
        
    var uuid = UUID()
    @State var ucEntryViewType: UCEntryViewType = .table
    @State var ucEntry: UCEntry

    static func == (lhs: UCEntryView, rhs: UCEntryView) -> Bool {
        return lhs.ucEntry == rhs.ucEntry
    }

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
            HStack {
                Text(ucEntry.leftLabel)
                    .foregroundColor(ucEntry.leftLabelColor)
                    .frame(alignment: .leading)
                    .font(.system(size: ucEntry.listFontSize))
                Spacer()
                Text(ucEntry.middleLabel)
                    .foregroundColor(ucEntry.middleLabelColor)
                    .frame(alignment: .center)
                    .font(.system(size: ucEntry.listFontSize))
                Spacer()
                Text(ucEntry.value)
                    .foregroundColor(ucEntry.valueColor)
                    .frame(alignment: .trailing)
                    .font(.system(size: ucEntry.listFontSize))
                Text(ucEntry.unit)
                    .foregroundColor(ucEntry.unitColor)
                    .frame(alignment: .leading)
                    .font(.system(size: ucEntry.listFontSize))
                Text(ucEntry.rightLabel)
                    .foregroundColor(ucEntry.rightLabelColor)
                    .frame(alignment: .trailing)
                    .font(.system(size: ucEntry.listFontSize))
            }
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
    var maxLinesInDayTable: Int
    @State var maxEntriesInTable: Int = 0
    @EnvironmentObject var detailedEntryList: EntryList

    public init(
        ucDay: UCDay,
        maxLinesInDayTable: Int
    ) {
        self.ucDay = ucDay
        self.maxLinesInDayTable = maxLinesInDayTable
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
            ForEach (0..<self.maxEntriesInTable, id: \.self) { index in
                UCEntryView(
                    ucEntryViewType: .table,
                    ucEntry: self.ucDay.ucEntries[index]
                )
            }
            ForEach (0..<(self.maxLinesInDayTable-self.maxEntriesInTable), id: \.self) { _ in
                UCEntryView(
                    ucEntryViewType: .table,
                    ucEntry: UCEntry()
                )
            }
        }
        .onAppear() {
            if self.ucDay.ucEntries.count >= self.maxLinesInDayTable {
                self.maxEntriesInTable = self.maxLinesInDayTable
            } else {
                self.maxEntriesInTable = ucDay.ucEntries.count
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
        .onTapGesture {
            detailedEntryList.entryList.removeAll()
            ucDay.ucEntries.forEach{ucEntry in
                detailedEntryList.entryList.append(UCEntryView(ucEntryViewType: .list, ucEntry: ucEntry))
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
    private var maxLinesInDayTable: Int

    public init(
        ucWeek: UCWeek,
        maxLinesInDayTable: Int
    ) {
        self.ucWeek = ucWeek
        self.maxLinesInDayTable = maxLinesInDayTable
    }

    public var body: some View {
        HStack {
            ForEach (self.ucWeek.ucDays, id: \.uuid) { ucDay in
                UCDayView(
                    ucDay: ucDay,
                    maxLinesInDayTable: maxLinesInDayTable
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
    private var ucMonth: UCMonth
    private var maxLinesInDayTable: Int

    init(
        ucMonth: UCMonth,
        maxLinesInDayTable: Int
    ) {
        self.ucMonth = ucMonth
        self.maxLinesInDayTable = maxLinesInDayTable
    }

    public var body: some View {
        VStack {
            ForEach (self.ucMonth.ucWeeks, id: \.uuid) { ucWeek in
                UCWeekView(
                    ucWeek: ucWeek,
                    maxLinesInDayTable: maxLinesInDayTable
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
    private var maxLinesInDayTable: Int
    @ObservedObject private var obsObject = ObserveModel()
    @EnvironmentObject var detailedEntryList: EntryList

    public init(
        month: Date,
        ucEntries: [UCEntry],
        maxLinesInDayTable: Int
    ) {
        _month = State(initialValue: month.resetTime())
        self._ucEntries = Binding {return ucEntries} set: { newValue in
        }
        self.maxLinesInDayTable = maxLinesInDayTable
        
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
    }

    public var body: some View {
        UCMonthView(ucMonth: self.ucMonth, maxLinesInDayTable: maxLinesInDayTable)
        VStack {
            Rectangle()
                .fill(Color(uiColor: UIColor.rgba(red: 0xF0, green: 0xF0, blue: 0xF0, alpha: 0xFF)))
                .frame(height: 25)
            List{
                ForEach(detailedEntryList.entryList, id: \.uuid) { ucEntryView in
                    ucEntryView
                }
            }
            .onChange(of: detailedEntryList.entryList, perform: { _ in
                obsObject.count += 1
            })
        }
    }
}
