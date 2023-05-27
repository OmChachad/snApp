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
        VStack {
            Form {
                Section {
                    Picker("Appearance Style", selection: $appearance) {
                        ForEach(Appearance.allCases, id: \.self) { appearance in
                            Text(appearance.rawValue)
                                .tag(appearance)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .formStyle(.grouped)
            Text("Windows is a trademark of Microsoft Corporation\niPadOS is a trademark of Apple Inc.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.horizontal, 5)
        }
    }
}

enum Appearance: String, Codable, CaseIterable {
    case win11 = "Windows"
    case iPad = "iPadOS"
}

struct AppearanceSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceSettings()
    }
}
