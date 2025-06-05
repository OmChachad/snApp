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
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(1)
            
            AppearanceSettings()
                .tabItem {
                    Label("Appearance", systemImage: "paintbrush.fill")
                }
                .tag(2)
            
            TipJar()
                .environmentObject(Store.shared)
                .tabItem {
                    Label("Tip Jar", systemImage: "heart.fill")
                }
                .tag(3)
            
            About()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(4)
        }
        .frame(width: 400, height: current == 3 ? 500 : 350)
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
