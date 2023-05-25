//
//  AppearanceSettings.swift
//  snApp
//
//  Created by Om Chachad on 03/03/23.
//

import SwiftUI

struct AppearanceSettings: View {
    @AppStorage("AppearanceStyle") var appearance: Appearance = .win11
    
    var body: some View {
        Form {
            Section {
                Picker("Appearance Style", selection: $appearance) {
                    ForEach(Appearance.allCases, id: \.self) { appearance in
                        Text(appearance.rawValue)
                            .tag(appearance)
                    }
                }
                .pickerStyle(.segmented)
            } footer: {
                Text("Relaunch the app for the changes to take effect.")
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
    }
}

enum Appearance: String, Codable, CaseIterable {
    case win11 = "Win 11"
    case iPad = "iPad"
}

struct AppearanceSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceSettings()
    }
}
