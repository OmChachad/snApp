//
//  Settings.swift
//  snApp
//
//  Created by Om Chachad on 23/02/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var current = 1
    var body: some View {
        TabView(selection: $current) {
            GeneralSettings()
            
            //.fixedSize()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(1)
            
                AppearanceSettings()
                .tabItem {
                    Label("Appearance", systemImage: "paintbrush.fill")
                }
                .tag(2)
            
            MenuBar()
                .tabItem {
                    Label("Appearance", systemImage: "paintbrush.fill")
                }
                .tag(3)
        }
        .animation(.default, value: current)
        .onAppear {
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}

//struct Settings_Previews: PreviewProvider {
//    static var previews: some View {
//        Settings()
//    }
//}
