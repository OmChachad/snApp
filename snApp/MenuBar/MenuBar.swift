//
//  MenuBar.swift
//  snApp
//
//  Created by Om Chachad on 05/02/23.
//

import SwiftUI
import ScriptingBridge

struct MenuBar: View {
    @State private var showingOptionsMenu = false
    @AppStorage("SnapInstalled") var snapInstallationStatus = false
    @Environment(\.openURL) var openURL
    @AppStorage("AppHidden") var isAppHidden = false
    @Environment(\.openWindow) var openWindow
    @AppStorage("AppearanceStyle") var appearance: Appearance = .win11
    @AppStorage("showSettingsButton") var showSettingsButton = true
    
    var body: some View {
        VStack(spacing: 0) {
            if snapInstallationStatus == false || !isSnapUpdated() {
                VStack {
                    SnapInstallationChecker()
                }
                Button("Open Settings") {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                }
            } else if showingOptionsMenu {
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
                    }
                }
                .transition(.push(from: .top))
            }
            
        }
        .padding(showSettingsButton ? 7.5 : 0)
        .padding(10)
        .padding(.horizontal, 2.5)
        .onChange(of: NSEvent.modifierFlags) { newValue in
            print(newValue)
            if newValue.contains(.option) {
                showingOptionsMenu = true
            } else {
                showingOptionsMenu = false
            }
        }
        .animation(.default, value: showingOptionsMenu)
        .onAppear(perform: {
            NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { event in
                self.showingOptionsMenu = event.modifierFlags.contains(.option)
                return event
            }
        })
        .overlay(alignment: .topLeading) {
            if showSettingsButton || showingOptionsMenu {
                Button {
                    showingOptionsMenu.toggle()
                } label: {
                    if !showingOptionsMenu {
                        Image(systemName: "gear")
                            .foregroundColor(.secondary)
                            .imageScale(.medium)
                    } else {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.secondary)
                            .imageScale(.large)
                            .padding(2)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.secondary.opacity(0.4))
                            }
                    }
                }
                .padding(5)
                .buttonStyle(.borderless)
            }
        }
    }
}

@ViewBuilder
func iPadStyle() -> some View {
    VStack(spacing: 10) {
        HStack {
            LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)) {
                iPadButton(systemName: "rectangle.leadinghalf.inset.filled", position: "Left Half")
                iPadButton(systemName: "rectangle.leadingthird.inset.filled", position: "Left Third")
                iPadButton(systemName: "rectangle.inset.filled", position: "Fit Screen")
                Button {
                    snapTo(position: "Middle Third")
                } label: {
                    middleThird()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .contentShape(Rectangle())
                }
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
            
            Divider()
            
            LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)) {
                Button {
                    snapTo(position: "Left Two Third")
                } label: {
                    leftTwoThird()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .contentShape(Rectangle())
                }
                
                Button {
                    snapTo(position: "Right Two Third")
                } label: {
                    rightTwoThird()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .contentShape(Rectangle())
                }
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
            .contentShape(Rectangle())
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
    }
}

struct middleThird: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.13888*width, y: 0.89146*height))
        path.addLine(to: CGPoint(x: 0.86112*width, y: 0.89146*height))
        path.addCurve(to: CGPoint(x: 0.99805*width, y: 0.75614*height), control1: CGPoint(x: 0.95294*width, y: 0.89146*height), control2: CGPoint(x: 0.99805*width, y: 0.84635*height))
        path.addLine(to: CGPoint(x: 0.99805*width, y: 0.24386*height))
        path.addCurve(to: CGPoint(x: 0.86112*width, y: 0.10854*height), control1: CGPoint(x: 0.99805*width, y: 0.15365*height), control2: CGPoint(x: 0.95294*width, y: 0.10854*height))
        path.addLine(to: CGPoint(x: 0.13888*width, y: 0.10854*height))
        path.addCurve(to: CGPoint(x: 0.00195*width, y: 0.24386*height), control1: CGPoint(x: 0.0476*width, y: 0.10854*height), control2: CGPoint(x: 0.00195*width, y: 0.15365*height))
        path.addLine(to: CGPoint(x: 0.00195*width, y: 0.75614*height))
        path.addCurve(to: CGPoint(x: 0.13888*width, y: 0.89146*height), control1: CGPoint(x: 0.00195*width, y: 0.84635*height), control2: CGPoint(x: 0.0476*width, y: 0.89146*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.13996*width, y: 0.81359*height))
        path.addCurve(to: CGPoint(x: 0.07928*width, y: 0.75238*height), control1: CGPoint(x: 0.10129*width, y: 0.81359*height), control2: CGPoint(x: 0.07928*width, y: 0.79265*height))
        path.addLine(to: CGPoint(x: 0.07928*width, y: 0.24762*height))
        path.addCurve(to: CGPoint(x: 0.13996*width, y: 0.18641*height), control1: CGPoint(x: 0.07928*width, y: 0.20681*height), control2: CGPoint(x: 0.10129*width, y: 0.18641*height))
        path.addLine(to: CGPoint(x: 0.86004*width, y: 0.18641*height))
        path.addCurve(to: CGPoint(x: 0.92072*width, y: 0.24762*height), control1: CGPoint(x: 0.8987*width, y: 0.18641*height), control2: CGPoint(x: 0.92072*width, y: 0.20681*height))
        path.addLine(to: CGPoint(x: 0.92072*width, y: 0.75238*height))
        path.addCurve(to: CGPoint(x: 0.86004*width, y: 0.81359*height), control1: CGPoint(x: 0.92072*width, y: 0.79265*height), control2: CGPoint(x: 0.8987*width, y: 0.81359*height))
        path.addLine(to: CGPoint(x: 0.13996*width, y: 0.81359*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.43449*width, y: 0.75131*height))
        path.addLine(to: CGPoint(x: 0.56497*width, y: 0.75131*height))
        path.addCurve(to: CGPoint(x: 0.59827*width, y: 0.71694*height), control1: CGPoint(x: 0.58967*width, y: 0.75131*height), control2: CGPoint(x: 0.59827*width, y: 0.74164*height))
        path.addLine(to: CGPoint(x: 0.59827*width, y: 0.28306*height))
        path.addCurve(to: CGPoint(x: 0.56497*width, y: 0.2487*height), control1: CGPoint(x: 0.59827*width, y: 0.25782*height), control2: CGPoint(x: 0.58967*width, y: 0.2487*height))
        path.addLine(to: CGPoint(x: 0.43449*width, y: 0.2487*height))
        path.addCurve(to: CGPoint(x: 0.40173*width, y: 0.28306*height), control1: CGPoint(x: 0.41032*width, y: 0.2487*height), control2: CGPoint(x: 0.40173*width, y: 0.25782*height))
        path.addLine(to: CGPoint(x: 0.40173*width, y: 0.71694*height))
        path.addCurve(to: CGPoint(x: 0.43449*width, y: 0.75131*height), control1: CGPoint(x: 0.40173*width, y: 0.74164*height), control2: CGPoint(x: 0.41032*width, y: 0.75131*height))
        path.closeSubpath()
        return path
    }
}

struct leftTwoThird: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.13888*width, y: 0.89146*height))
        path.addLine(to: CGPoint(x: 0.86112*width, y: 0.89146*height))
        path.addCurve(to: CGPoint(x: 0.99805*width, y: 0.75614*height), control1: CGPoint(x: 0.95294*width, y: 0.89146*height), control2: CGPoint(x: 0.99805*width, y: 0.84635*height))
        path.addLine(to: CGPoint(x: 0.99805*width, y: 0.24386*height))
        path.addCurve(to: CGPoint(x: 0.86112*width, y: 0.10854*height), control1: CGPoint(x: 0.99805*width, y: 0.15365*height), control2: CGPoint(x: 0.95294*width, y: 0.10854*height))
        path.addLine(to: CGPoint(x: 0.13888*width, y: 0.10854*height))
        path.addCurve(to: CGPoint(x: 0.00195*width, y: 0.24386*height), control1: CGPoint(x: 0.0476*width, y: 0.10854*height), control2: CGPoint(x: 0.00195*width, y: 0.15365*height))
        path.addLine(to: CGPoint(x: 0.00195*width, y: 0.75614*height))
        path.addCurve(to: CGPoint(x: 0.13888*width, y: 0.89146*height), control1: CGPoint(x: 0.00195*width, y: 0.84635*height), control2: CGPoint(x: 0.0476*width, y: 0.89146*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.13996*width, y: 0.81359*height))
        path.addCurve(to: CGPoint(x: 0.07928*width, y: 0.75238*height), control1: CGPoint(x: 0.10129*width, y: 0.81359*height), control2: CGPoint(x: 0.07928*width, y: 0.79265*height))
        path.addLine(to: CGPoint(x: 0.07928*width, y: 0.24762*height))
        path.addCurve(to: CGPoint(x: 0.13996*width, y: 0.18641*height), control1: CGPoint(x: 0.07928*width, y: 0.20681*height), control2: CGPoint(x: 0.10129*width, y: 0.18641*height))
        path.addLine(to: CGPoint(x: 0.86004*width, y: 0.18641*height))
        path.addCurve(to: CGPoint(x: 0.92072*width, y: 0.24762*height), control1: CGPoint(x: 0.8987*width, y: 0.18641*height), control2: CGPoint(x: 0.92072*width, y: 0.20681*height))
        path.addLine(to: CGPoint(x: 0.92072*width, y: 0.75238*height))
        path.addCurve(to: CGPoint(x: 0.86004*width, y: 0.81359*height), control1: CGPoint(x: 0.92072*width, y: 0.79265*height), control2: CGPoint(x: 0.8987*width, y: 0.81359*height))
        path.addLine(to: CGPoint(x: 0.13996*width, y: 0.81359*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.14229*width, y: 0.27966*height))
        path.addCurve(to: CGPoint(x: 0.17326*width, y: 0.2487*height), control1: CGPoint(x: 0.14229*width, y: 0.26256*height), control2: CGPoint(x: 0.15615*width, y: 0.2487*height))
        path.addLine(to: CGPoint(x: 0.58941*width, y: 0.2487*height))
        path.addCurve(to: CGPoint(x: 0.62037*width, y: 0.27966*height), control1: CGPoint(x: 0.60651*width, y: 0.2487*height), control2: CGPoint(x: 0.62037*width, y: 0.26256*height))
        path.addLine(to: CGPoint(x: 0.62037*width, y: 0.72033*height))
        path.addCurve(to: CGPoint(x: 0.58941*width, y: 0.7513*height), control1: CGPoint(x: 0.62037*width, y: 0.73744*height), control2: CGPoint(x: 0.60651*width, y: 0.7513*height))
        path.addLine(to: CGPoint(x: 0.17326*width, y: 0.7513*height))
        path.addCurve(to: CGPoint(x: 0.14229*width, y: 0.72033*height), control1: CGPoint(x: 0.15615*width, y: 0.7513*height), control2: CGPoint(x: 0.14229*width, y: 0.73744*height))
        path.addLine(to: CGPoint(x: 0.14229*width, y: 0.27966*height))
        path.closeSubpath()
        return path
    }
}

struct rightTwoThird: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.13888*width, y: 0.89146*height))
        path.addLine(to: CGPoint(x: 0.86112*width, y: 0.89146*height))
        path.addCurve(to: CGPoint(x: 0.99805*width, y: 0.75614*height), control1: CGPoint(x: 0.95294*width, y: 0.89146*height), control2: CGPoint(x: 0.99805*width, y: 0.84635*height))
        path.addLine(to: CGPoint(x: 0.99805*width, y: 0.24386*height))
        path.addCurve(to: CGPoint(x: 0.86112*width, y: 0.10854*height), control1: CGPoint(x: 0.99805*width, y: 0.15365*height), control2: CGPoint(x: 0.95294*width, y: 0.10854*height))
        path.addLine(to: CGPoint(x: 0.13888*width, y: 0.10854*height))
        path.addCurve(to: CGPoint(x: 0.00195*width, y: 0.24386*height), control1: CGPoint(x: 0.0476*width, y: 0.10854*height), control2: CGPoint(x: 0.00195*width, y: 0.15365*height))
        path.addLine(to: CGPoint(x: 0.00195*width, y: 0.75614*height))
        path.addCurve(to: CGPoint(x: 0.13888*width, y: 0.89146*height), control1: CGPoint(x: 0.00195*width, y: 0.84635*height), control2: CGPoint(x: 0.0476*width, y: 0.89146*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.13996*width, y: 0.81359*height))
        path.addCurve(to: CGPoint(x: 0.07928*width, y: 0.75238*height), control1: CGPoint(x: 0.10129*width, y: 0.81359*height), control2: CGPoint(x: 0.07928*width, y: 0.79265*height))
        path.addLine(to: CGPoint(x: 0.07928*width, y: 0.24762*height))
        path.addCurve(to: CGPoint(x: 0.13996*width, y: 0.18641*height), control1: CGPoint(x: 0.07928*width, y: 0.20681*height), control2: CGPoint(x: 0.10129*width, y: 0.18641*height))
        path.addLine(to: CGPoint(x: 0.86004*width, y: 0.18641*height))
        path.addCurve(to: CGPoint(x: 0.92072*width, y: 0.24762*height), control1: CGPoint(x: 0.8987*width, y: 0.18641*height), control2: CGPoint(x: 0.92072*width, y: 0.20681*height))
        path.addLine(to: CGPoint(x: 0.92072*width, y: 0.75238*height))
        path.addCurve(to: CGPoint(x: 0.86004*width, y: 0.81359*height), control1: CGPoint(x: 0.92072*width, y: 0.79265*height), control2: CGPoint(x: 0.8987*width, y: 0.81359*height))
        path.addLine(to: CGPoint(x: 0.13996*width, y: 0.81359*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.38133*width, y: 0.27966*height))
        path.addCurve(to: CGPoint(x: 0.41229*width, y: 0.2487*height), control1: CGPoint(x: 0.38133*width, y: 0.26256*height), control2: CGPoint(x: 0.39519*width, y: 0.2487*height))
        path.addLine(to: CGPoint(x: 0.82845*width, y: 0.2487*height))
        path.addCurve(to: CGPoint(x: 0.85941*width, y: 0.27966*height), control1: CGPoint(x: 0.84555*width, y: 0.2487*height), control2: CGPoint(x: 0.85941*width, y: 0.26256*height))
        path.addLine(to: CGPoint(x: 0.85941*width, y: 0.72033*height))
        path.addCurve(to: CGPoint(x: 0.82845*width, y: 0.7513*height), control1: CGPoint(x: 0.85941*width, y: 0.73744*height), control2: CGPoint(x: 0.84555*width, y: 0.7513*height))
        path.addLine(to: CGPoint(x: 0.41229*width, y: 0.7513*height))
        path.addCurve(to: CGPoint(x: 0.38133*width, y: 0.72033*height), control1: CGPoint(x: 0.39519*width, y: 0.7513*height), control2: CGPoint(x: 0.38133*width, y: 0.73744*height))
        path.addLine(to: CGPoint(x: 0.38133*width, y: 0.27966*height))
        path.closeSubpath()
        return path
    }
}
