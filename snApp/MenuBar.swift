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


struct Stack: View {
    var orientation: Orientation
    var buttons: [String]
    
    var body: some View {
        let layout = orientation == .horizontal ? AnyLayout(HStackLayout(spacing: 5)) : AnyLayout(VStackLayout(spacing: 5))
        layout {
            ForEach(buttons, id: \.self) { button in
                SnapButton(position: button)
            }
        }
        .frame(height: 50)
        .padding(.vertical, 5)
        .padding(.horizontal, 2.5)
        
    }
}

struct AdaptiveStack: View {
    @State private var hoveringLeft = false
    @State private var hoveringRight = false
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Group {
                    SnapButton(position: "Left Two Third")
                        .frame(maxWidth: hoveringRight ? geo.size.width*1/3 : .infinity)
                        .overlay {
                            Text("⅔")
                                .foregroundColor(.primary.opacity(0.7))
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .allowsHitTesting(false)
                        }
                    
                    Spacer()
                        .frame(width: 2.5)
                }
                .onHover { state in
                    hoveringLeft = state
                }
                
                Group {
                    Spacer()
                        .frame(width: 2.5)
                    
                    SnapButton(position: "Right Two Third")
                        .frame(maxWidth: hoveringLeft ? geo.size.width*1/3 : .infinity)
                        .overlay {
                            Text("⅔")
                                .foregroundColor(.primary.opacity(0.7))
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .allowsHitTesting(false)
                        }
                }
                .onHover { state in
                    hoveringRight = state
                }
            }
            .frame(height: 50)
        }
        .animation(.default.speed(2), value: hoveringLeft)
        .animation(.default.speed(2), value: hoveringRight)
        .padding(.vertical, 5)
        .padding(.horizontal, 2.5)
        
    }
}


func snapTo(position: String) {
    var argument = ""
    // Retrieve the stored SnapMode value from UserDefaults
    if let storedSnapModeString = UserDefaults.standard.string(forKey: "SnapMode") {
        if let storedSnapMode = SnapMode(rawValue: storedSnapModeString) {
            
            if storedSnapMode == .snap {
                argument = "echo \(position) | shortcuts run Snap"
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
            
        }
    }


    let task = Process.launchedProcess(launchPath: "/bin/bash", arguments: ["-c", argument])

    do {
        try task.run()
        task.waitUntilExit()
    } catch {
        withAnimation {
            SnapInstallationChecker().isSnapInstalled()
        }
    }
}

struct QuadStack: View {
    var buttons: [String]
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 5) {
            ForEach(buttons, id: \.self) { button in
                SnapButton(position: button)
                    .frame(width: 36)
            }
        }
        .frame(height: 50)
        .padding(.vertical, 5)
        .padding(.horizontal, 2.5)
    }
}

enum Orientation {
    case vertical
    case horizontal
}

struct SnapButton: View {
    var position: String
    @State private var opacity = 0.25
    
    var body: some View {
        Button {
            opacity = 0.5
            
            snapTo(position: position)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    opacity = 0.25
                }
            }
        } label: {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .foregroundColor(.primary.opacity(opacity))
                .shadow(color: .secondary,radius: 10)
                .frame(minHeight: 22.5, maxHeight: .infinity)
                .accessibilityLabel(position)
                .accessibilityHint("Snap window to \(position)")
        }
        .buttonStyle(.borderless)
        .frame(maxWidth: .infinity)
    }
}
