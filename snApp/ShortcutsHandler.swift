//
//  ShortcutsHandler.swift
//  snApp
//
//  Created by Om Chachad on 18/03/23.
//

import Foundation
import ScriptingBridge

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
}

func isShortcutInstalled(withName shortcut: String) -> Bool {
    guard
        let app: ShortcutsEvents = SBApplication(bundleIdentifier: "com.apple.shortcuts.events"),
        let shortcuts = app.shortcuts else {
        return false
    }

    guard shortcuts.object(withName: shortcut) is Shortcut else {
        return false
    }
    
    return true
}
