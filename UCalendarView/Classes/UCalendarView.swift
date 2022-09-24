import Foundation
import SwiftUI

class ObserveModel: ObservableObject{
    @Published var count = 0
}

public class EntryList: ObservableObject {
    @Published var entryList: [UCEntryView] = []
    
    public init() {}
}

public class BeltDate: ObservableObject {
    @Published var date: Date = Date().resetTime()
}

public class CalendarDate: ObservableObject {
    @Published var date: Date = Date().resetTime()
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
    var tableAlignment: Alignment = .leading

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
        listFontSize: CGFloat,
        tableAlignment: Alignment
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
        self.tableAlignment = tableAlignment
    }
    
}

struct UCEntryView: View, Equatable {
        
    var uuid = UUID()
    @State var ucEntryViewType: UCEntryViewType = .table
    @State var ucEntry: UCEntry
    @ObservedObject private var obsObject = ObserveModel()
    @EnvironmentObject var calendarDate: CalendarDate

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
            HStack {
                switch ucEntry.tableAlignment {
                case .center:
                    Text(ucEntry.value)
                        .foregroundColor(ucEntry.valueColor)
                        .frame(alignment: .trailing)
                        .font(.system(size: ucEntry.tableFontSize))
                case.trailing:
                    Spacer()
                    Text(ucEntry.value)
                        .foregroundColor(ucEntry.valueColor)
                        .frame(alignment: .trailing)
                        .font(.system(size: ucEntry.tableFontSize))
                default:
                    Text(ucEntry.value)
                        .foregroundColor(ucEntry.valueColor)
                        .frame(alignment: .trailing)
                        .font(.system(size: ucEntry.tableFontSize))
                    Spacer()
                }
            }
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
    @ObservedObject private var obsObject = ObserveModel()
    @EnvironmentObject var detailedEntryList: EntryList
    @EnvironmentObject var beltDate: BeltDate
    @EnvironmentObject var calendarDate: CalendarDate

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
        .border(Color(UIColor.rgba(red: 0xE0, green: 0xE0, blue: 0xE0, alpha: 0xFF)), width: 1)
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
            beltDate.date = ucDay.date
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
    @ObservedObject private var obsObject = ObserveModel()
    @EnvironmentObject var calendarDate: CalendarDate

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
    @ObservedObject private var obsObject = ObserveModel()
    @EnvironmentObject var calendarDate: CalendarDate

    init(
        ucMonth: UCMonth,
        maxLinesInDayTable: Int
    ) {
        self.ucMonth = ucMonth
        self.maxLinesInDayTable = maxLinesInDayTable
    }

    public var body: some View {
        VStack {
            HStack {
                Text("LabelSunday")
                    .frame(alignment: .center)
                Text("LabelMonday")
                    .frame(alignment: .center)
                Text("LabelTuesday")
                    .frame(alignment: .center)
                Text("LabelWednesday")
                    .frame(alignment: .center)
                Text("LabelThursday")
                    .frame(alignment: .center)
                Text("LabelFriday")
                    .frame(alignment: .center)
                Text("LabelSaturday")
                    .frame(alignment: .center)
            }
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
    let endDate = calendar.date(
        byAdding: .day,
        value: 7*6-1,
        to: startDate
    )!.resetTime()
    return endDate
}

private func ucEntriesInMonth(
    month: Date,
    inUcEntries: [UCEntry]
) -> [UCEntry] {
    let outUcEntries =  inUcEntries.filter{ startDateInMonth(month: month) <= $0.date && $0.date <= endDateInMonth(month: month) }
    return outUcEntries
}

private struct DateBelt: View {
    @State var dateFormatter = DateFormatter()
    @EnvironmentObject var beltDate: BeltDate
    
    public var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color(uiColor: UIColor.rgba(red: 0xF0, green: 0xF0, blue: 0xF0, alpha: 0xFF)))
                .frame(height: 25)
            HStack {
                Text(dateFormatter.string(from: beltDate.date))
                    .frame(alignment: .leading)
                Spacer()
            }
            Button("+", action: {
            })
        }
        .onAppear() {
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-M-d"
        }
    }
    
}

private var ucMonth: UCMonth = UCMonth(month: Date().resetTime(), ucWeeks: [])

private struct UCalendarViewImpl: View {

    var month: Date
    var ucEntries: [UCEntry]
    // @State private var ucMonth: UCMonth = UCMonth(month: Date().resetTime(), ucWeeks: [])
    private var maxLinesInDayTable: Int
    private var endDate: Date?
    @ObservedObject private var obsObject = ObserveModel()
    @EnvironmentObject var detailedEntryList: EntryList
    @EnvironmentObject var calendarDate: CalendarDate

    init(
        month: Date,
        ucEntries: [UCEntry],
        maxLinesInDayTable: Int,
        endDate: Date?
    ) {
        self.month = month.resetTime()
        self.ucEntries = ucEntries
        self.maxLinesInDayTable = maxLinesInDayTable
        self.endDate = endDate

        var ucWeeks: [UCWeek] = []
        var ucDays: [UCDay] = []

        let calendar = Calendar(identifier: .gregorian)
        var pointedDate = startDateInMonth(month: month)
        ucDays.removeAll()
        for _ in 1...42 {
            let ucDay = UCDay(date: pointedDate, ucEntries: ucEntriesInMonth(month: month, inUcEntries: self.ucEntries))
            ucDays.append(ucDay)
            pointedDate = calendar.date(byAdding: .day, value: 1, to: pointedDate.resetTime())!
        }
        ucWeeks.removeAll()
        for week in 1...6 {
            let ucWeek = UCWeek(
                thisMonth: calendar.component(.month, from: month),
                weekOfMonth:week,
                ucDays: ucDays
            )
            ucWeeks.append(ucWeek)
        }
        ucMonth = UCMonth(month: month, ucWeeks: ucWeeks)
    }

    func reEntry(month: Date) {
        var ucWeeks: [UCWeek] = []
        var ucDays: [UCDay] = []

        let calendar = Calendar(identifier: .gregorian)
        var pointedDate = startDateInMonth(month: month)
        ucDays.removeAll()
        for _ in 1...42 {
            let ucDay = UCDay(date: pointedDate, ucEntries: ucEntriesInMonth(month: month, inUcEntries: self.ucEntries))
            ucDays.append(ucDay)
            pointedDate = calendar.date(byAdding: .day, value: 1, to: pointedDate.resetTime())!
        }
        ucWeeks.removeAll()
        for week in 1...6 {
            let ucWeek = UCWeek(
                thisMonth: calendar.component(.month, from: month),
                weekOfMonth:week,
                ucDays: ucDays
            )
            ucWeeks.append(ucWeek)
        }
        ucMonth = UCMonth(month: month, ucWeeks: ucWeeks)
    }
    
    public var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    Spacer()
                    Button(
                        action: {
                            calendarDate.date = Calendar.current.date(byAdding: .month, value: -1, to: calendarDate.date.resetTime())!
                            ucMonth.month = calendarDate.date
                            reEntry(month: calendarDate.date)
                            obsObject.count += 1
                        },
                        label: {
                            Label("", systemImage: "chevron.left")
                        }
                    )
                    Spacer()
                    if self.endDate != nil {
                        DatePicker("",
                                   selection: $calendarDate.date,
                                   in: ...self.endDate!,
                                   displayedComponents: .date)
                        .onChange(of: calendarDate.date, perform: { date in
                            calendarDate.date = date.resetTime()
                            ucMonth.month = calendarDate.date
                            reEntry(month: calendarDate.date)
                            obsObject.count += 1
                        })
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                        .labelsHidden()
                    } else {
                        DatePicker("",
                                   selection: $calendarDate.date,
                                   displayedComponents: .date)
                        .onChange(of: calendarDate.date, perform: { date in
                            calendarDate.date = date.resetTime()
                            ucMonth.month = calendarDate.date
                            reEntry(month: calendarDate.date)
                            obsObject.count += 1
                        })
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                        .labelsHidden()
                    }
                    Spacer()
                    Button(
                        action: {
                            let tempDate = Calendar.current.date(byAdding: .month, value: 1, to: calendarDate.date.resetTime())!
                            if self.endDate != nil {
                                if tempDate <= self.endDate! {
                                    calendarDate.date = tempDate.resetTime()
                                    ucMonth.month = calendarDate.date
                                    reEntry(month: calendarDate.date)
                                    obsObject.count += 1
                                }
                            } else {
                                calendarDate.date = tempDate.resetTime()
                                ucMonth.month = calendarDate.date
                                reEntry(month: calendarDate.date)
                                obsObject.count += 1
                            }
                        },
                        label: {
                            Label("", systemImage: "chevron.right")
                        }
                    )
                    .padding(.leading, 10.0)
                    Spacer()
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        calendarDate.date = Date().resetTime()
                        ucMonth.month = calendarDate.date
                        reEntry(month: calendarDate.date)
                        obsObject.count += 1
                    }, label: {
                        Label("", systemImage: "calendar")
                    })
                    .frame(alignment: .trailing)
                    .padding(.trailing)
                }
            }
            UCMonthView(ucMonth: ucMonth, maxLinesInDayTable: maxLinesInDayTable)
            VStack {
                DateBelt()
                List{
                    ForEach(detailedEntryList.entryList, id: \.uuid) { ucEntryView in
                        ucEntryView
                    }
                }
                .listStyle(PlainListStyle())
                .onChange(of: detailedEntryList.entryList, perform: { _ in
                    obsObject.count += 1
                })
            }
        }
        .onChange(of: calendarDate.date, perform: { date in
            reEntry(month: date)
            obsObject.count += 1
        })
        .onAppear() {
            calendarDate.date = self.month.resetTime()
            reEntry(month: calendarDate.date)
        }
    }
}

public struct UCalendarView: View {

    var month: Date
    var ucEntries: [UCEntry]
    private var maxLinesInDayTable: Int

    public init(
        month: Date,
        ucEntries: [UCEntry],
        maxLinesInDayTable: Int
    ) {
        self.month = month
        self.ucEntries = ucEntries
        self.maxLinesInDayTable = maxLinesInDayTable
    }

    public var body: some View {
        UCalendarViewImpl(month: month.resetTime(), ucEntries: ucEntries, maxLinesInDayTable: maxLinesInDayTable, endDate: nil)
            .environmentObject(EntryList())
            .environmentObject(BeltDate())
            .environmentObject(CalendarDate())
    }
}

