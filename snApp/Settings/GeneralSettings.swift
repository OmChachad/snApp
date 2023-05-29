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
    @AppStorage("showSettingsButton") var showSettingsButton = true
    
    @Environment(\.openURL) var openURL
    @State private var showIntroduction = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    HStack(spacing: 85) {
                        SnapInstallationChecker(snapIsInstalled: SnapIsInstalled)
                    }
                    
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
                VStack(alignment: .leading) {
                    Toggle("Show Settings Button", isOn: $showSettingsButton)
                        .toggleStyle(.switch)
                    Text("Disabling this will hide the \(Image(systemName: "gear")) icon at the top left of the Menu Bar window. You can still access Settings when the Menu Bar window is open, by holding down ⌥ or pressing ⌘,")
                        .foregroundColor(.secondary)
                        .font(.callout)
                        .padding(.trailing, 40)
                }
            } footer: {
                
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



