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
    @State var ucAddCallback: ((UCAddEntry) -> Void)? = nil

    func addUCEntry(ucAddEntry: UCAddEntry, ucAddCallback: @escaping (UCAddEntry) -> Void) {
        self.ucAddEntry = ucAddEntry
        self.ucAddCallback = ucAddCallback
        self.isShowingAdd = true
    }

    @State var ucDeleteEntry = UCDeleteEntry()

    func deleteUCEntry(ucDeleteEntry: UCDeleteEntry) {
    }

    @State var ucEditEntry = UCEditEntry()
    @State var ucEditCallback: ((UCEditEntry) -> Void)? = nil

    func editUCEntry(ucEditEntry: UCEditEntry, ucEditCallback: @escaping (UCEditEntry) -> Void) {
        self.ucEditEntry = ucEditEntry
        self.ucEditCallback = ucEditCallback
        self.isShowingEdit = true
    }
    
    @State var myCallback = UCCallback()
    
    @State var isShowingAdd = false
    @State var isShowingDelete = false
    @State var isShowingEdit = false

    struct AddView: View {
        
        @State var value: String = ""
        @Binding var ucAddEntry: UCAddEntry
        @Binding var ucAddCallback: ((UCAddEntry) -> Void)?

        @Environment(\.dismiss) var dismiss
        
        init(
            ucAddEntry: Binding<UCAddEntry>,
            ucAddCallback: Binding<((UCAddEntry) -> Void)?>
        ) {
            _ucAddEntry = Binding(projectedValue: ucAddEntry)
            _ucAddCallback = Binding(projectedValue: ucAddCallback)
        }
        
        var body: some View {
            VStack {
                HStack {
                    TextField("Value", text: $value)
                        .border(.black)
                        .onChange(of: value, perform: { newValue in
                            ucAddEntry.value = newValue
                        })
                        .padding()
                }
                Button {
                    ucAddEntry.applicationTag = UUID().uuidString
                    ucAddEntry.leftLabel = "Left"
                    ucAddEntry.leftLabelColor = Color.cyan
                    ucAddEntry.middleLabel = "Middle"
                    ucAddEntry.middleLabelColor = Color.cyan
                    ucAddEntry.valueColor = Color.red
                    ucAddEntry.unit = "Unit"
                    ucAddEntry.unitColor = Color.blue
                    ucAddEntry.rightLabel = "Right"
                    ucAddEntry.rightLabelColor = Color.cyan
                    ucAddEntry.tableFontSize = 10.0
                    ucAddEntry.listFontSize = 12.0
                    ucAddEntry.tableAlignment = .trailing
                    ucAddCallback?(ucAddEntry)
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
    }

    
    struct EditView: View {
        
        @State var value: String = ""
        @Binding var ucEditEntry: UCEditEntry
        @Binding var ucEditCallback: ((UCEditEntry) -> Void)?

        @Environment(\.dismiss) var dismiss
        
        init(
            ucEditEntry: Binding<UCEditEntry>,
            ucEditCallback: Binding<((UCEditEntry) -> Void)?>
        ) {
            _ucEditEntry = Binding(projectedValue: ucEditEntry)
            _ucEditCallback = Binding(projectedValue: ucEditCallback)
        }
        
        var body: some View {
            VStack {
                HStack {
                    TextField("Value", text: $value)
                        .border(.black)
                        .onChange(of: value, perform: { newValue in
                            ucEditEntry.value = newValue
                        })
                        .padding()
                }
                Button {
                    ucEditCallback?(ucEditEntry)
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
    }

    var body: some View {
        
        UCalendarView(month: self.month, ucEntries: self.ucEntries, maxLinesInDayTable: 5, addButton: true)
            .onAppear() {
                let calendar = Calendar(identifier: .gregorian)
                var components = DateComponents()
                components.year = calendar.component(.year, from: month)
                components.month = calendar.component(.month, from: month)
                for day in 1...28 {
                    components.day = day
                    for item in 1...3 {
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
                myCallback.addUCEntry = addUCEntry(ucAddEntry: ucAddCallback:)
                myCallback.deleteUCEntry = deleteUCEntry(ucDeleteEntry:)
                myCallback.editUCEntry = editUCEntry(ucEditEntry: ucEditCallback:)
                registerCallback(ucCallback: myCallback)
            }
            .sheet(isPresented: $isShowingAdd, content: {
                AddView(ucAddEntry: self.$ucAddEntry, ucAddCallback: self.$ucAddCallback)
            })
            .sheet(isPresented: $isShowingEdit, content: {
                // EditView(ucEditEntry: self.ucEditEntry, ucEditCallback: self.ucEditCallback!)
                // ↑本来、これでOKなはずだか、なぜかself.ucEditCallbackにnilが入る。
                // Appleの不具合と思われるが、Appleは直す様子がない。
                EditView(ucEditEntry: self.$ucEditEntry, ucEditCallback: self.$ucEditCallback)
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
