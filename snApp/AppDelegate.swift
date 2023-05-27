//
//  AppDelegate.swift
//  snApp
//
//  Created by Om Chachad on 27/05/23.
//

import Foundation
import SwiftUI
import FluidMenuBarExtra

class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuBarExtra: FluidMenuBarExtra?
    @AppStorage("AppearanceStyle") var appearance: Appearance = .win11
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setMenuBar()
    }
    
    func setMenuBar() {
        self.menuBarExtra = FluidMenuBarExtra(title: "Snapp", systemImage: appearance == .win11 ? "rectangle.grid.2x2.fill" : "ellipsis") {
            MenuBar()
        }
    }
}
