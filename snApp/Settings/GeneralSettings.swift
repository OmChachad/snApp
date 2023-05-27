//
//  ContentView.swift
//  snApp
//
//  Created by Om Chachad on 05/02/23.
//

import SwiftUI
import ServiceManagement

struct GeneralSettings: View {
    @AppStorage("SnapInstalled") var SnapIsInstalled = false
    @AppStorage("AppHidden") var isAppHidden = false
    
    @AppStorage("SnapMode") var snapMode: SnapMode = .snap
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Form {
            Section {
                HStack {
                    SnapInstallationChecker(snapInstallationStatus: SnapIsInstalled)
                    if SnapIsInstalled {
                        Spacer()
                        Button("Run") {
                            let task = Process.launchedProcess(launchPath: "/bin/bash", arguments: ["-c", "shortcuts run Snap"])
                            
                            try? task.run()
                            task.waitUntilExit()
                        }
                        Button("View") {
                            let task = Process.launchedProcess(launchPath: "/bin/bash", arguments: ["-c", "open \"shortcuts://open-shortcut?name=Snap\""])
                            
                            try? task.run()
                            task.waitUntilExit()
                        }
                    }
                }
                if SnapIsInstalled == true {
                    LogInToggle()
                }
            }
            
            Section {
                Picker("Snap Mode", selection: $snapMode) {
                    ForEach(SnapMode.allCases, id: \.self) { item in
                        Text(item.rawValue.capitalized).tag(item)
                    }
                }
            }
            
            Section {
                HStack {
                    Button("Snap Website") {
                        openURL(URL(string: "https://itecheverything.com/snap")!)
                    }
                    
                    Spacer()
                    
                    Button("Developer's Website") {
                        openURL(URL(string: "https://starlightapps.org/")!)
                    }
                }
                .buttonStyle(.link)
            }
            
        }
        .formStyle(.grouped)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettings()
    }
}

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


enum SnapMode: String, Codable, CaseIterable {
    case snap
    case raycast
}



