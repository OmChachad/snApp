//
//  ShortcutsHandler.swift
//  snApp
//
//  Created by Om Chachad on 18/03/23.
//

import Foundation
import ScriptingBridge
import SwiftUI

@objc protocol ShortcutsEvents {
    @objc optional var shortcuts: SBElementArray { get }
}
@objc protocol Shortcut {
    @objc optional var name: String { get }
    @objc optional func run(withInput: Any?) -> Any?
}

extension SBApplication: ShortcutsEvents {}
extension SBObject: Shortcut {}


func runShortcut(named shortcut: String, withInput: String?) {
    DispatchQueue.global().async {
        guard
            let app: ShortcutsEvents = SBApplication(bundleIdentifier: "com.apple.shortcuts.events"),
            let shortcuts = app.shortcuts else {
            print("Couldn't access shortcuts")
            return
        }
        
        guard let shortcut = shortcuts.object(withName: shortcut) as? Shortcut else {
            print("Shortcut doesn't exist")
            return
        }
        
        _ = shortcut.run?(withInput: withInput)
    }
    refreshInstallationStatus()
}

//func isShortcutInstalled(withName shortcut: String) -> Bool {
//    guard
//        let app: ShortcutsEvents = SBApplication(bundleIdentifier: "com.apple.shortcuts.events"),
//        let shortcuts = app.shortcuts else {
//        return false
//    }
//
//    guard shortcuts.object(withName: shortcut) is Shortcut else {
//        return false
//    }
//
//    return true
//}

func isSnapInstalled() -> Bool {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["shortcuts", "list"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    if let output = String(data: data, encoding: .utf8) {
        for i in output.split(separator: "\n") {
            if i == "Snap" {
                UserDefaults.standard.set(true, forKey: "SnapInstalled")
                return true
            }
        }
        return false
    } else {
        return false
    }
}

func updateShortcutVersionNumber() {
    UserDefaults.standard.set(snapShortcut.versionNumber, forKey: "ShortcutVersion")
}

func isSnapUpdated() -> Bool {
    UserDefaults.standard.double(forKey: "ShortcutVersion") == snapShortcut.versionNumber
}

func snapTo(position: String) {
    var argument = ""
    // Retrieve the stored SnapMode value from UserDefaults
    //if let storedSnapModeString = UserDefaults.standard.string(forKey: "SnapMode") {
       // if let storedSnapMode = SnapMode(rawValue: storedSnapModeString) {
            
            if true {
                //argument = "echo \(position) | shortcuts run Snap"
                runShortcut(named: "Snap", withInput: position)
                return
            } else {
                let snapToRayCastDictionary = [
                    "Left Half" : "Left Half",
                    "Right Half" : "Right Half",
                    "Top Left Quarter" : "Top Left Quarter",
                    "Top Right Quarter" : "Top Right Quarter",
                    "Bottom Left Quarter" : "Bottom Left Quarter",
                    "Bottom Right Quarter" : "Bottom Right Quarter",
                    "Left Third" : "First Third",
                    "Middle Third" : "Center Third",
                    "Right Third" : "Last Third",
                    "Top Half" : "Top Half",
                    "Bottom Half" : "Bottom Half",
                    "Fit Screen" : "Maximize",
                    "Left Two Third" : "First Two Thirds",
                    "Right Two Third" : "Last Two Thirds"
                ]
                let raycastPosition = snapToRayCastDictionary[position] ?? "Maximise"
                let subdirectory = raycastPosition.replacingOccurrences(of: " ", with: "-").lowercased()
                argument = "open -g raycast://extensions/raycast/window-management/\(subdirectory)"
            }
            
       // }
   // }
    
    
    let task = Process.launchedProcess(launchPath: "/bin/bash", arguments: ["-c", argument])
    
    do {
        try task.run()
        task.waitUntilExit()
    } catch {
        refreshInstallationStatus()
    }
}

func refreshInstallationStatus() {
    withAnimation {
        print("Hi")
        UserDefaults.standard.set(isSnapInstalled(), forKey: "SnapInstalled")
    }
}
