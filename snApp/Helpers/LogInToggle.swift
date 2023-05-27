//
//  LogInToggle.swift
//  snApp
//
//  Created by Om Chachad on 27/05/23.
//

import SwiftUI
import ServiceManagement

struct LogInToggle: View {
    @State private var startAtLogin = false
    var body: some View {
        Toggle("Start at login", isOn: $startAtLogin)
            .toggleStyle(.switch)
            .onAppear(perform: checkForLogInItem)
            .onChange(of: startAtLogin) { _ in toggleLogInItem() }
    }
    
    func checkForLogInItem() -> Void {
        startAtLogin = SMAppService.mainApp.status == .enabled
    }
    
    func toggleLogInItem() -> Void {
        if startAtLogin == false {
            try? SMAppService.mainApp.unregister()
        } else {
            try? SMAppService.mainApp.register()
        }
    }
}
