//
//  ContentView.swift
//  snApp
//
//  Created by Om Chachad on 05/02/23.
//

import SwiftUI

struct GeneralSettings: View {
    @AppStorage("SnapInstalled") var SnapIsInstalled = false
    @AppStorage("SnapMode") var snapMode: SnapMode = .snap
    
    @Environment(\.openURL) var openURL
    @State private var showIntroduction = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    SnapInstallationChecker(snapIsInstalled: SnapIsInstalled)
                    
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
            
            if false {
                Section {
                    Picker("Snap Mode", selection: $snapMode) {
                        ForEach(SnapMode.allCases, id: \.self) { item in
                            Text(item.rawValue)
                                .tag(item)
                        }
                    }
                }
            }
            
            Section {
                HStack {
                    Text("Walkthrough")
                    Spacer()
                    Button("Start") {
                        showIntroduction.toggle()
                    }
                }
            }
            
            Section {
                HStack {
//                    Button("Snap Website") {
//                        openURL(URL(string: "https://itecheverything.com/snap")!)
//                    }
                    
                    Spacer()
                    
                    Button("Developer's Website") {
                        openURL(URL(string: "https://starlightapps.org/")!)
                    }
                }
                .buttonStyle(.link)
            }
            
        }
        .formStyle(.grouped)
        .sheet(isPresented: $showIntroduction, content: {Introduction(completionAction: {
            showIntroduction.toggle()
        })})
    }
}


enum SnapMode: String, Codable, CaseIterable {
    case snap = "Snap"
    case raycast = "Raycast"
}



