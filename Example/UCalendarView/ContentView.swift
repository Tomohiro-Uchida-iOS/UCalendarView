//
//  ContentView.swift
//  UCalendarView_Example
//
//  Created by Tomohiro Uchida on 2022/09/04.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import UCalendarView

struct ContentView: View {
    
    var month = Date()
    @State var ucEntries: [UCEntry] = []
    
    init() {
    }

    @State var ucAddEntry = UCAddEntry()
    
    func addUCEntry(ucAddEntry: inout UCAddEntry) {
        print("addUCEntry:", ucAddEntry.applicationTag)
    }
    
    @State var ucDeleteEntry = UCDeleteEntry()

    func deleteUCEntry(ucDeleteEntry: UCDeleteEntry) {
        print("deleteUCEntry:", ucDeleteEntry.applicationTag)
    }
    
    @State var ucEditEntry = UCEditEntry()
    
    func editUCEntry(ucEditEntry: inout UCEditEntry) {
        print("editUCEntry:", ucEditEntry.applicationTag)
        print("editUCEntry:", ucEditEntry.value)
        ucEditEntry.value = "Value-0"
    }
    
    @State var myCallback = UCCallback()
    
    var body: some View {
                
        UCalendarView(month: self.month, ucEntries: self.ucEntries, maxLinesInDayTable: 5, addButton: true)
            .onAppear() {
                let calendar = Calendar(identifier: .gregorian)
                var components = DateComponents()
                components.year = calendar.component(.year, from: month)
                components.month = calendar.component(.month, from: month)
                for day in 1...28 {
                    components.day = day
                    for item in 1...10 {
                        let ucEntry = UCEntry(
                            applicationTag: NSUUID().uuidString,
                            date: calendar.date(from: components)!,
                            leftLabel: "Left",
                            leftLabelColor: Color.cyan,
                            middleLabel: "Middle",
                            middleLabelColor: Color.cyan,
                            value: String(format: "Entry %d-%d", day, item),
                            valueColor: Color.red,
                            unit: "Unit",
                            unitColor: Color.blue,
                            rightLabel: "Right",
                            rightLabelColor: Color.cyan,
                            tableFontSize: 10.0,
                            listFontSize: 12.0,
                            tableAlignment: .trailing
                        )
                        self.ucEntries.append(ucEntry)
                    }
                }
                myCallback.addUCEntry = addUCEntry(ucAddEntry:)
                myCallback.deleteUCEntry = deleteUCEntry(ucDeleteEntry:)
                myCallback.editUCEntry = editUCEntry(ucEditEntry:)
                registerCallback(ucCallback: myCallback)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
