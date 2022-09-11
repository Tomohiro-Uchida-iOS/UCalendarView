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
    
    @State var month = Date().resetTime()
    @State var ucEntries: [UCEntry] = []
    
    var body: some View {
        UCalendarView(month: self.month, ucEntries: self.$ucEntries)
            .onAppear() {
                let calendar = Calendar(identifier: .gregorian)
                var components = DateComponents()
                components.year = calendar.component(.year, from: month)
                components.month = calendar.component(.month, from: month)
                for day in 1...28 {
                    components.day = day
                    let ucEntry = UCEntry(
                        date: calendar.date(from: components)!,
                        leftLabel: "Left",
                        leftLabelColor: Color.cyan,
                        middleLabel: "Middle",
                        middleLabelColor: Color.cyan,
                        value: String(format: "Value=%d", day),
                        valueColor: Color.red,
                        unit: "Unit",
                        unitColor: Color.blue,
                        rightLabel: "Right",
                        rightLabelColor: Color.cyan,
                        tableFontSize: 8.0)
                    self.ucEntries.append(ucEntry)
                }
            }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
