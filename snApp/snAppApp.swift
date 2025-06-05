//
//  snAppApp.swift
//  snApp
//
//  Created by Om Chachad on 05/02/23.
//

import SwiftUI
import FluidMenuBarExtra

@main
struct snAppApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @AppStorage("AppearanceStyle") var appearance: Appearance = .win11
    
    @AppStorage("showIntroduction") private var showIntroduction = true
    
    init() {
        showIntroductionView(isPresented: $showIntroduction)
    }
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
        .defaultPosition(.center)
        .onChange(of: appearance) { _ in
            appDelegate.setMenuBar()
        }
        
        WindowGroup("Tip Jar", id: "TipJar") {
            TipJar()
                .frame(idealWidth: 400, idealHeight: 500)
                .environmentObject(Store.shared)
        }
        .defaultSize(width: 400, height: 500)
    }
}
