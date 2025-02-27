//
//  SiriShortcut.swift
//  snApp
//
//  Created by Om Chachad on 2/27/25.
//

import Foundation

struct SiriShortcut {
    var name: String
    var urlString: String
    var versionNumber: Double
    
    var url: URL {
        updateShortcutVersionNumber()
        return URL(string: urlString)!
    }
}
