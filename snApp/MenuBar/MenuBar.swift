//
//  MenuBar.swift
//  snApp
//
//  Created by Om Chachad on 05/02/23.
//

import SwiftUI
import ScriptingBridge

struct MenuBar: View {
    @State private var isOptionKeyPressed = false
    @AppStorage("SnapInstalled") var snapInstallationStatus = false
    @Environment(\.openURL) var openURL
    @AppStorage("AppHidden") var isAppHidden = false
    @Environment(\.openWindow) var openWindow
    @AppStorage("AppearanceStyle") var appearance: Appearance = .win11
    
    var body: some View {
        VStack(spacing: 0) {
            if snapInstallationStatus == false {
                SnapInstallationChecker()
                Button("Open Settings") {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                }
            } else if isOptionKeyPressed {
                VStack(spacing: 10) {
                    Button("Open Settings") {
                        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                        NSApp.activate(ignoringOtherApps: true)
                    }
                    
                    Button("Quit App") {
                        NSApplication.shared.terminate(nil)
                    }
                }
                .frame(width: appearance == .win11 ? 255 : 240, height: appearance == .win11 ? 120 : 55)
                .transition(.push(from: .bottom))
            } else {
                Group {
                    switch(appearance) {
                    case .win11:
                        win11Style()
                    case .iPad:
                        iPadStyle()
                    default:
                        win11Style()
                    }
                }
                .transition(.push(from: .top))
            }
            
        }
        .padding(10)
        .padding(.horizontal, 2.5)
        .onChange(of: NSEvent.modifierFlags) { newValue in
            print(newValue)
            if newValue.contains(.option) {
                isOptionKeyPressed = true
            } else {
                isOptionKeyPressed = false
            }
        }
        .animation(.default, value: isOptionKeyPressed)
        .onAppear(perform: {
            NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { event in
                self.isOptionKeyPressed = event.modifierFlags.contains(.option)
                return event
            }
        })
    }
    
    func iPadStyle() -> some View {
        VStack(spacing: 10) {
            HStack {
                LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)) {
                    iPadButton(systemName: "rectangle.leadinghalf.inset.filled", position: "Left Half")
                    iPadButton(systemName: "rectangle.leadingthird.inset.filled", position: "Left Third")
                    iPadButton(systemName: "rectangle.inset.filled", position: "Fit Screen")
                    iPadButton(systemName: "rectangle.center.inset.filled", position: "Middle Third")
                    iPadButton(systemName: "rectangle.trailinghalf.inset.filled", position: "Right Half")
                    iPadButton(systemName: "rectangle.trailingthird.inset.filled", position: "Right Third")
                }
                
                Divider()
                
                LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)) {
                    iPadButton(systemName: "rectangle.inset.topleading.filled", position: "Top Left Quarter")
                    iPadButton(systemName: "rectangle.inset.bottomleading.filled", position: "Bottom Left Quarter")
                    
                    iPadButton(systemName: "rectangle.inset.toptrailing.filled", position: "Top Right Quarter")
                    iPadButton(systemName: "rectangle.inset.bottomtrailing.filled", position: "Bottom Right Quarter")
                }
                
                Divider()
                
                LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)) {
                    iPadButton(systemName: "rectangle.tophalf.inset.filled", position: "Top Half")
                    iPadButton(systemName: "rectangle.bottomhalf.inset.filled", position: "Bottom Half")
                }
            }
        }
        .buttonStyle(.plain)
        .font(.title)
        .padding(.vertical, 5)
    }

    @ViewBuilder
    private func iPadButton(systemName: String, position: String) -> some View {
        Button {
            snapTo(position: position)
        } label: {
            Image(systemName: systemName)
        }
    }

    
    func win11Style() -> some View {
        VStack {
            LazyVGrid(columns: [
                GridItem(.fixed(80)),
                GridItem(.fixed(80)),
                GridItem(.fixed(80))
            ], spacing: 0) {
                
                Stack(orientation: .horizontal, buttons: ["Left Half", "Right Half"])
                
                QuadStack(buttons: ["Top Left Quarter", "Top Right Quarter", "Bottom Left Quarter", "Bottom Right Quarter"])
                
                Stack(orientation: .vertical, buttons: ["Top Half", "Bottom Half"])
                
                Stack(orientation: .horizontal, buttons: ["Left Third", "Middle Third", "Right Third"])
                
                SnapButton(position: "Fit Screen")
                    .frame(height: 50)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 2.5)
                
                AdaptiveStack()
            }
            .frame(maxWidth: .infinity)
        }
    }
}
