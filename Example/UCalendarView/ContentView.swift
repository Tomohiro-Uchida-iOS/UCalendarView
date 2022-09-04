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

    @State var entries: [UCEntry] = Array(repeating: UCEntry(), count: 3)
    
    var body: some View {
        UCalendarView(entries: entries)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
