import Foundation
import SwiftUI

class ObserveModel: ObservableObject{
    @Published var count = 0
}

public class EntryList: ObservableObject {
    @Published var entries: [UCEntry] = []
    
    public init() {}
}

public class EntryViewList: ObservableObject {
    @Published var entryViewList: [UCEntryView] = []
    
    public init() {}
}

public class BeltDate: ObservableObject {
    @Published var enabled: Bool = false
    @Published var date: Date = Date().resetTime()

    public init() {}
}

public class CalendarDate: ObservableObject {
    @Published var date: Date = Date().resetTime()

    public init() {}
}

enum UCEntryViewType {
    case table
    case list
}

public class UCEntry: Equatable {
    var uuid = UUID()
    var applicationTag: String = ""
    var date: Date = Date().resetTime()
    var leftLabel: String = ""
    var leftLabelColor: Color = Color.black
    var middleLabel: String = ""
    var middleLabelColor: Color = Color.black
    var value: String = "          "  // Space, not empty String
    var valueColor: Color = Color.black
    var unit: String = ""
    var unitColor: Color = Color.black
    var rightLabel: String = ""
    var rightLabelColor: Color = Color.black
    var tableFontSize: CGFloat = 10.0
    var listFontSize: CGFloat = 12.0
    var tableAlignment: Alignment = .leading

    public static func == (lhs: UCEntry, rhs: UCEntry) -> Bool {
        return lhs.applicationTag == rhs.applicationTag &&
        lhs.date == rhs.date &&
        lhs.leftLabel == rhs.leftLabel &&
        lhs.middleLabel == rhs.middleLabel &&
        lhs.value == rhs.value &&
        lhs.unit == rhs.unit &&
        lhs.rightLabel == rhs.rightLabel
    }
    
    public init() {}
    
    public init(
        applicationTag: String,
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
        self.applicationTag = applicationTag
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
    @EnvironmentObject var obsObject: ObserveModel
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
        self.ucEntries = ucEntries
    }
}

private struct UCDayView: View {
    private var ucDay: UCDay
    @State var ucDayType: UCDayViewType = .weekday
    var maxLinesInDayTable: Int
    @State var maxEntriesInTable: Int = 0
    @EnvironmentObject var obsObject: ObserveModel
    @EnvironmentObject var detailedEntryViewList: EntryViewList
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
        ZStack {
            if beltDate.enabled && beltDate.date == ucDay.date {
                Color(UIColor.rgba(red: 0xFF, green: 0xF5, blue: 0x9D, alpha: 0xFF))
            } else if ucDay.date == Date().resetTime() {
                Color(UIColor.rgba(red: 0xE0, green: 0xE0, blue: 0xE0, alpha: 0xFF))
            } else {
                Color(.clear)
            }
            VStack() {
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
            if beltDate.enabled && beltDate.date == ucDay.date {
                beltDate.enabled = false
            } else {
                beltDate.enabled = true
            }
            beltDate.date = ucDay.date
            detailedEntryViewList.entryViewList.removeAll()
            if beltDate.enabled {
                ucDay.ucEntries.forEach{ucEntry in
                    detailedEntryViewList.entryViewList.append(UCEntryView(ucEntryViewType: .list, ucEntry: ucEntry))
                }
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
    @EnvironmentObject var obsObject: ObserveModel
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
    @EnvironmentObject var obsObject: ObserveModel
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
                let bundle = Bundle(identifier: "com.jimdo.uchida001tmhr.UCalendarView")
                Group {
                    Spacer()
                    Text(NSLocalizedString("LabelSunday", bundle: bundle!, comment: ""))
                        .frame(alignment: .center)
                        .foregroundColor(Color.red)
                        .padding(.all, 0)
                    Spacer()
                    Spacer()
                    Text(NSLocalizedString("LabelMonday", bundle: bundle!, comment: ""))
                        .frame(alignment: .center)
                        .padding(.all, 0)
                    Spacer()
                }
                Group {
                    Spacer()
                    Text(NSLocalizedString("LabelTuesday", bundle: bundle!, comment: ""))
                        .frame(alignment: .center)
                        .padding(.all, 0)
                    Spacer()
                    Spacer()
                    Text(NSLocalizedString("LabelWednesday", bundle: bundle!, comment: ""))
                        .frame(alignment: .center)
                        .padding(.all, 0)
                    Spacer()
                }
                Group {
                    Spacer()
                    Text(NSLocalizedString("LabelThursday", bundle: bundle!, comment: ""))
                        .frame(alignment: .center)
                        .padding(.all, 0)
                    Spacer()
                    Spacer()
                    Text(NSLocalizedString("LabelFriday", bundle: bundle!, comment: ""))
                        .frame(alignment: .center)
                        .padding(.all, 0)
                    Spacer()
                    Spacer()
                    Text(NSLocalizedString("LabelSaturday", bundle: bundle!, comment: ""))
                        .frame(alignment: .center)
                        .foregroundColor(Color.blue)
                        .padding(.all, 0)
                    Spacer()
                }
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

private func ucEntriesInDay(
    date: Date,
    inUcEntries: [UCEntry]
) -> [UCEntry] {
    let outUcEntries =  inUcEntries.filter{ $0.date == date }
    return outUcEntries
}


private var ucMonth: UCMonth = UCMonth(month: Date().resetTime(), ucWeeks: [])
private var entryList = EntryList()

private struct UCalendarViewImpl: View {

    private var month: Date
    private var maxLinesInDayTable: Int
    private var startDate: Date?
    private var endDate: Date?
    private var addButton: Bool
    @EnvironmentObject var obsObject: ObserveModel
    @EnvironmentObject var detailedEntryViewList: EntryViewList
    @EnvironmentObject var calendarDate: CalendarDate
    @EnvironmentObject var beltDate: BeltDate

    init(
        month: Date,
        ucEntries: [UCEntry],
        maxLinesInDayTable: Int,
        startDate: Date?,
        endDate: Date?,
        addButton: Bool
    ) {
        self.month = month.resetTime()
        self.maxLinesInDayTable = maxLinesInDayTable
        self.startDate = startDate
        self.endDate = endDate
        self.addButton = addButton

        entryList.entries = ucEntries
        reEntry(month: self.month, actionDetailedEntryViewList: .stay)
        
    }
    
    enum ActionDetailedEntryViewList {
        case stay
        case clear
        case display
    }
        
    func reEntry(month: Date, actionDetailedEntryViewList: ActionDetailedEntryViewList) {
        var ucWeeks: [UCWeek] = []
        var ucDays: [UCDay] = []
       
        let calendar = Calendar(identifier: .gregorian)
        var pointedDate = startDateInMonth(month: month)
        ucDays.removeAll()
        if actionDetailedEntryViewList == .clear || actionDetailedEntryViewList == .display {
            detailedEntryViewList.entryViewList.removeAll()
        }
        for _ in 1...42 {
            let ucDay = UCDay(date: pointedDate, ucEntries: ucEntriesInDay(date: pointedDate, inUcEntries: entryList.entries))
            ucDays.append(ucDay)
            if actionDetailedEntryViewList == .display {
                if beltDate.enabled && beltDate.date == pointedDate {
                    ucDay.ucEntries.forEach{ucEntry in
                        detailedEntryViewList.entryViewList.append(UCEntryView(ucEntryViewType: .list, ucEntry: ucEntry))
                    }
                }
            }
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
    
    private func getIndexFromApplicationTag(applicationTag: String) -> Int {
        var index = 0
        for ucEntry in entryList.entries {
            if ucEntry.applicationTag == applicationTag {
                return index
            }
            index += 1
        }
        return -1
    }

    private func ucAddCallback(ucAddEntry: UCAddEntry) {
        let ucEntry = UCEntry()
        ucEntry.date = ucAddEntry.date
        ucEntry.leftLabel = ucAddEntry.leftLabel
        ucEntry.leftLabelColor = ucAddEntry.leftLabelColor
        ucEntry.middleLabel = ucAddEntry.middleLabel
        ucEntry.middleLabelColor = ucAddEntry.middleLabelColor
        ucEntry.value = ucAddEntry.value
        ucEntry.valueColor = ucAddEntry.valueColor
        ucEntry.unit = ucAddEntry.unit
        ucEntry.unitColor = ucAddEntry.unitColor
        ucEntry.rightLabel = ucAddEntry.rightLabel
        ucEntry.rightLabelColor = ucAddEntry.rightLabelColor
        ucEntry.tableFontSize = ucAddEntry.tableFontSize
        ucEntry.listFontSize = ucAddEntry.listFontSize
        ucEntry.tableAlignment = ucAddEntry.tableAlignment
        entryList.entries.append(ucEntry)
        obsObject.objectWillChange.send()
    }

    private func ucEditCallback(ucEditEntry: UCEditEntry) {
        let index = getIndexFromApplicationTag(applicationTag: ucEditEntry.applicationTag)
        if index > 0 {
            entryList.entries[index].date = ucEditEntry.date
            entryList.entries[index].leftLabel = ucEditEntry.leftLabel
            entryList.entries[index].leftLabelColor = ucEditEntry.leftLabelColor
            entryList.entries[index].middleLabel = ucEditEntry.middleLabel
            entryList.entries[index].middleLabelColor = ucEditEntry.middleLabelColor
            entryList.entries[index].value = ucEditEntry.value
            entryList.entries[index].valueColor = ucEditEntry.valueColor
            entryList.entries[index].unit = ucEditEntry.unit
            entryList.entries[index].unitColor = ucEditEntry.unitColor
            entryList.entries[index].rightLabel = ucEditEntry.rightLabel
            entryList.entries[index].rightLabelColor = ucEditEntry.rightLabelColor
            entryList.entries[index].tableFontSize = ucEditEntry.tableFontSize
            entryList.entries[index].listFontSize = ucEditEntry.listFontSize
            entryList.entries[index].tableAlignment = ucEditEntry.tableAlignment
            obsObject.objectWillChange.send()
        }
    }
    
    private struct DateBelt: View {
        private var addButton: Bool
        @State var dateFormatter = DateFormatter()
        @EnvironmentObject var beltDate: BeltDate
        private var ucAddCallback: (UCAddEntry) -> Void
        
        init(
            addButton: Bool,
            ucAddCallback: @escaping (UCAddEntry) -> Void
        ) {
            self.addButton = addButton
            self.ucAddCallback = ucAddCallback
        }
        
        public var body: some View {
            
            ZStack {
                Rectangle()
                    .fill(Color(uiColor: UIColor.rgba(red: 0xF0, green: 0xF0, blue: 0xF0, alpha: 0xFF)))
                    .frame(height: 25)
                HStack {
                    if beltDate.enabled {
                        Text(dateFormatter.string(from: beltDate.date))
                            .frame(alignment: .leading)
                        Spacer()
                    }
                }
                if addButton {
                    Button("+", action: {
                        let ucAddEntry = UCAddEntry()
                        if beltDate.enabled {
                            ucAddEntry.date = beltDate.date
                        } else {
                            ucAddEntry.date = Date().resetTime()
                        }
                        gUcCallback.addUCEntry?(ucAddEntry, self.ucAddCallback)
                    })
                }
            }
            .onAppear() {
                dateFormatter.locale = Locale(identifier: "ja_JP")
                dateFormatter.dateStyle = .medium
                dateFormatter.dateFormat = "yyyy-M-d"
            }
        }
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
                            beltDate.enabled = false
                            reEntry(month: calendarDate.date, actionDetailedEntryViewList: .clear)
                            obsObject.objectWillChange.send()
                        },
                        label: {
                            Label("", systemImage: "chevron.left")
                        }
                    )
                    Spacer()
                    if self.startDate == nil && self.endDate == nil {
                        DatePicker("",
                                   selection: $calendarDate.date,
                                   displayedComponents: .date)
                        .onChange(of: calendarDate.date, perform: { date in
                            calendarDate.date = date.resetTime()
                            ucMonth.month = calendarDate.date
                            beltDate.enabled = false
                            reEntry(month: calendarDate.date, actionDetailedEntryViewList: .clear)
                            obsObject.objectWillChange.send()
                        })
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                        .labelsHidden()
                    } else if self.startDate != nil && self.endDate == nil {
                        DatePicker("",
                                   selection: $calendarDate.date,
                                   in: self.startDate!...,
                                   displayedComponents: .date)
                        .onChange(of: calendarDate.date, perform: { date in
                            calendarDate.date = date.resetTime()
                            ucMonth.month = calendarDate.date
                            beltDate.enabled = false
                            reEntry(month: calendarDate.date, actionDetailedEntryViewList: .clear)
                            obsObject.objectWillChange.send()
                        })
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                        .labelsHidden()

                    } else if self.startDate == nil && self.endDate != nil {
                        DatePicker("",
                                   selection: $calendarDate.date,
                                   in: ...self.endDate!,
                                   displayedComponents: .date)
                        .onChange(of: calendarDate.date, perform: { date in
                            calendarDate.date = date.resetTime()
                            ucMonth.month = calendarDate.date
                            beltDate.enabled = false
                            reEntry(month: calendarDate.date, actionDetailedEntryViewList: .clear)
                            obsObject.objectWillChange.send()
                        })
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                        .labelsHidden()
                    } else {
                        DatePicker("",
                                   selection: $calendarDate.date,
                                   in: self.startDate!...self.endDate!,
                                   displayedComponents: .date)
                        .onChange(of: calendarDate.date, perform: { date in
                            calendarDate.date = date.resetTime()
                            ucMonth.month = calendarDate.date
                            beltDate.enabled = false
                            reEntry(month: calendarDate.date, actionDetailedEntryViewList: .clear)
                            obsObject.objectWillChange.send()
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
                                    beltDate.enabled = false
                                    reEntry(month: calendarDate.date, actionDetailedEntryViewList: .clear)
                                    obsObject.objectWillChange.send()
                                }
                            } else {
                                calendarDate.date = tempDate.resetTime()
                                ucMonth.month = calendarDate.date
                                beltDate.enabled = false
                                reEntry(month: calendarDate.date, actionDetailedEntryViewList: .clear)
                                obsObject.objectWillChange.send()
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
                    let bundle = Bundle(identifier: "com.jimdo.uchida001tmhr.UCalendarView")
                    Button(NSLocalizedString("ButtonToday", bundle: bundle!,  comment: "")) {
                        calendarDate.date = Date().resetTime()
                        ucMonth.month = calendarDate.date
                        beltDate.enabled = false
                        reEntry(month: calendarDate.date, actionDetailedEntryViewList: .clear)
                        obsObject.objectWillChange.send()
                    }
                    .frame(alignment: .trailing)
                    .padding(.trailing)
                }
            }
            UCMonthView(ucMonth: ucMonth, maxLinesInDayTable: maxLinesInDayTable)
            VStack {
                DateBelt(addButton: addButton, ucAddCallback: ucAddCallback(ucAddEntry:))
                List{
                    ForEach(detailedEntryViewList.entryViewList, id: \.uuid) { ucEntryView in
                        ucEntryView
                            .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                                Button(action: {
                                    let ucEditEntry = UCEditEntry()
                                    ucEditEntry.applicationTag = ucEntryView.ucEntry.applicationTag
                                    ucEditEntry.date = ucEntryView.ucEntry.date
                                    ucEditEntry.leftLabel = ucEntryView.ucEntry.leftLabel
                                    ucEditEntry.leftLabelColor = ucEntryView.ucEntry.leftLabelColor
                                    ucEditEntry.middleLabel = ucEntryView.ucEntry.middleLabel
                                    ucEditEntry.middleLabelColor = ucEntryView.ucEntry.middleLabelColor
                                    ucEditEntry.value = ucEntryView.ucEntry.value
                                    ucEditEntry.valueColor = ucEntryView.ucEntry.valueColor
                                    ucEditEntry.unit = ucEntryView.ucEntry.unit
                                    ucEditEntry.unitColor = ucEntryView.ucEntry.unitColor
                                    ucEditEntry.rightLabel = ucEntryView.ucEntry.rightLabel
                                    ucEditEntry.rightLabelColor = ucEntryView.ucEntry.rightLabelColor
                                    ucEditEntry.tableFontSize = ucEntryView.ucEntry.tableFontSize
                                    ucEditEntry.listFontSize = ucEntryView.ucEntry.listFontSize
                                    ucEditEntry.tableAlignment = ucEntryView.ucEntry.tableAlignment
                                    gUcCallback.editUCEntry?(ucEditEntry, ucEditCallback(ucEditEntry:))
                                }, label: {
                                    Label("", systemImage: "square.and.pencil")
                                })
                                .tint(.orange)
                            })
                            .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                Button (role: .destructive, action: {
                                    let ucDeleteEntry = UCDeleteEntry()
                                    ucDeleteEntry.applicationTag = ucEntryView.ucEntry.applicationTag
                                    gUcCallback.deleteUCEntry?(ucDeleteEntry)
                                }, label: {
                                    Label("", systemImage: "trash")
                                })
                            })
                    }
                }
                .listStyle(PlainListStyle())
                .onChange(of: detailedEntryViewList.entryViewList, perform: { _ in
                    reEntry(month: calendarDate.date, actionDetailedEntryViewList: .display)
                    obsObject.objectWillChange.send()
                })
                .onChange(of: entryList.entries) { _ in
                    reEntry(month: calendarDate.date, actionDetailedEntryViewList: .display)
                    obsObject.objectWillChange.send()
                }
            }
        }
        .onChange(of: calendarDate.date, perform: { date in
            beltDate.enabled = false
            reEntry(month: date, actionDetailedEntryViewList: .clear)
            obsObject.objectWillChange.send()
        })
        .onAppear() {
            calendarDate.date = self.month.resetTime()
            beltDate.enabled = false
            reEntry(month: calendarDate.date, actionDetailedEntryViewList: .clear)
        }
    }
}

public class UCAddEntry {
    public var applicationTag: String = ""
    public var date: Date = Date().resetTime()
    public var leftLabel: String = ""
    public var leftLabelColor: Color = Color.black
    public var middleLabel: String = ""
    public var middleLabelColor: Color = Color.black
    public var value: String = "          "  // Space, not empty String
    public var valueColor: Color = Color.black
    public var unit: String = ""
    public var unitColor: Color = Color.black
    public var rightLabel: String = ""
    public var rightLabelColor: Color = Color.black
    public var tableFontSize: CGFloat = 10.0
    public var listFontSize: CGFloat = 12.0
    public var tableAlignment: Alignment = .leading
    
    public init() {}

}

public class UCDeleteEntry {
    public var applicationTag: String = ""
    
    public init() {}

}

public class UCEditEntry {
    public var applicationTag: String = ""
    public var date: Date = Date().resetTime()
    public var leftLabel: String = ""
    public var leftLabelColor: Color = Color.black
    public var middleLabel: String = ""
    public var middleLabelColor: Color = Color.black
    public var value: String = "          "  // Space, not empty String
    public var valueColor: Color = Color.black
    public var unit: String = ""
    public var unitColor: Color = Color.black
    public var rightLabel: String = ""
    public var rightLabelColor: Color = Color.black
    public var tableFontSize: CGFloat = 10.0
    public var listFontSize: CGFloat = 12.0
    public var tableAlignment: Alignment = .leading
        
    public init() {}

}

public class UCCallback {
    public var addUCEntry: ((_ ucAddEntry: UCAddEntry, _ ucAddCallback: @escaping (UCAddEntry) -> Void) -> Void)? = nil
    public var deleteUCEntry: ((_ ucDeleteEntry: UCDeleteEntry) -> Void)? = nil
    public var editUCEntry: ((_ ucEditEntry: UCEditEntry, _ ucEditCallback: @escaping (UCEditEntry) -> Void) -> Void)? = nil
    
    public init() {}
    
}

private var gUcCallback: UCCallback  = UCCallback()

public func registerCallback(
    ucCallback: UCCallback
) {
    gUcCallback = ucCallback
}


public struct UCalendarView: View {

    private var month: Date
    private var ucEntries: [UCEntry]
    private var maxLinesInDayTable: Int
    private var addButton: Bool

    public init(
        month: Date,
        ucEntries: [UCEntry],
        maxLinesInDayTable: Int,
        addButton: Bool
    ) {
        self.month = month
        self.ucEntries = ucEntries
        self.maxLinesInDayTable = maxLinesInDayTable
        self.addButton = addButton
    }

    public var body: some View {
        UCalendarViewImpl(
            month: month.resetTime(),
            ucEntries: ucEntries,
            maxLinesInDayTable: maxLinesInDayTable,
            startDate: nil,
            endDate: nil,
            addButton: addButton
        )
        .environmentObject(EntryViewList())
        .environmentObject(BeltDate())
        .environmentObject(CalendarDate())
        .environmentObject(ObserveModel())
    }
}

