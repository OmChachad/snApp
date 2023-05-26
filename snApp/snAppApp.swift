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
    
    var body: some Scene {
        /// NEED TO SHOW THIS LATER WITH ONBOARDING
//        WindowGroup {
//            Home()
//                .onAppear {
//                    NSApp.activate(ignoringOtherApps: true)
//                    NSApp.mainWindow?.orderFrontRegardless()
//                }
//
//
//        }
//            .windowResizability(.contentSize)
//            .defaultPosition(.center)

        Settings {
            SettingsView()
                .frame(minWidth: 350, minHeight: 210)
                .fixedSize()
        }
        .defaultPosition(.center)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuBarExtra: FluidMenuBarExtra?
    @AppStorage("AppearanceStyle") var appearance: Appearance = .win11
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        self.menuBarExtra = FluidMenuBarExtra(title: "Snapp", systemImage: appearance == .win11 ? "rectangle.grid.2x2.fill" : "ellipsis") {
            MenuBar()
        }
    }
}
