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
            .frame(minWidth: 350)
            .frame(minHeight: 175)
        }
        .defaultSize(width: 350, height: 175)
        .defaultPosition(.center)
        
        
//        MenuBarExtra("Snapp", systemImage: "rectangle.grid.2x2.fill") {
//            MenuBar()
//        }
//        .menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuBarExtra: FluidMenuBarExtra?

    func applicationDidFinishLaunching(_ notification: Notification) {
        self.menuBarExtra = FluidMenuBarExtra(title: "Snapp", systemImage: "rectangle.grid.2x2.fill") {
            MenuBar()
        }
    }
}
