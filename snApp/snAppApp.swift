//
//  snAppApp.swift
//  snApp
//
//  Created by Om Chachad on 05/02/23.
//

import SwiftUI
import FluidMenuBarExtra

@main
struct snAppApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @AppStorage("AppearanceStyle") var appearance: Appearance = .win11
    
    @State private var showIntroduction = true
    
    init() {
        if showIntroduction {
            showIntroductionView()
        }
    }
    
    var body: some Scene {
        Settings {
            SettingsView()
                .frame(minWidth: 350, minHeight: 210)
                .fixedSize()
        }
        .defaultPosition(.center)
        .onChange(of: appearance) { _ in
            appDelegate.setMenuBar()
        }
    }
    
    func showIntroductionView() {
        let onboardingWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 550),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .underWindowBackground
        
        let rootView = Introduction(completionAction: {
            showIntroduction = false
            NSApp.setActivationPolicy(.prohibited)
            onboardingWindow.close()
        })
        
        let hostingView = NSHostingView(rootView: rootView)
        hostingView.frame = visualEffectView.bounds
        hostingView.autoresizingMask = [.width, .height]
        
        visualEffectView.addSubview(hostingView)
        
        onboardingWindow.contentView = visualEffectView
        onboardingWindow.center()
        onboardingWindow.makeKeyAndOrderFront(nil)
        
        NSApp.setActivationPolicy(.regular)
    }


}

struct OnboardingView: View {
    let isComplete: () -> Void

    var body: some View {
        VStack {
            Text("Welcome to Your App")
                .font(.title)
                .padding()

            Text("Onboarding Content")
                .font(.subheadline)
                .padding()

            Button(action: isComplete) {
                Text("Get Started")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

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
