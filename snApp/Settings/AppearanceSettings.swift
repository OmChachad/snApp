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
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: appearance == .win11 ? "rectangle.grid.2x2.fill" : "ellipsis")
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.primary.opacity(0.2))
                                        .frame(width: 25, height: 20)
                                }
                            Image(systemName: "switch.2")
                            Text("9:41")
                        }
                        .padding(5)
                        .padding(.horizontal, 5)
                        .background(.primary.opacity(0.1))
                        
                        VStack {
                            switch(appearance) {
                            case .win11:
                                win11Style()
                            case .iPad:
                                iPadStyle()
                            }
                        }
                        .clipped()
                        .allowsHitTesting(false)
                        .frame(width: appearance == .win11 ? 255 : 240, height: appearance == .win11 ? 120 : 55)
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(.primary.opacity(0.2))
                                .background(.ultraThinMaterial)
                        }
                        .cornerRadius(15)
                        .shadow(radius: 1)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Spacer()
                    }
                    .frame(height: 190)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(.secondary.opacity(0.5), lineWidth: 1)

                    }
                    Picker("Appearance Style", selection: $appearance.animation()) {
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
