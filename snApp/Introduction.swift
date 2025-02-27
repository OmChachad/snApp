//
//  Introduction.swift
//  snApp
//
//  Created by Om Chachad on 26/05/23.
//

import SwiftUI
import AVKit

let snapShortcut = SiriShortcut(name: "Snap", urlString: "https://www.icloud.com/shortcuts/6e9ac882bad94858bb595e8bd8a28bc4", versionNumber: 3.0)

func showIntroductionView(isPresented: Binding<Bool>) {
    if isPresented.wrappedValue {
        let onboardingWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 550),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .underWindowBackground
        
        let rootView = Introduction(completionAction: {
            isPresented.wrappedValue = false
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
        NSApp.activate(ignoringOtherApps: true)
        NSApp.keyWindow?.orderFrontRegardless()
        for window in NSApplication.shared.windows {
                window.level = .floating
            }
    }
}


struct Introduction: View {
    @AppStorage("AppearanceStyle") var appearance: Appearance = .win11
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL
    let completionAction: () -> Void
    
    @State private var currentPage = 1
    let lastPage = 3
    
    @AppStorage("SnapInstalled") var snapInstallationStatus = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            switch(currentPage) {
            case 1:
                onboardingTemplate(media: {
                    VideoLooper(fileName: "\(colorScheme == .dark ? "Dark" : "Light")Demo", fileExtension: "mov")
                                            .aspectRatio(1370/700, contentMode: .fit)
                                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                            .shadow(radius: 10)
                }, title: "Welcome to snApp.", description: "Snap, the award winning Siri Shortcut, for incredible window management on macOS, is now available as an app. Quickly re-size and re-arrange windows however you like, inspired by Snap Layouts on Windows.")
            case 2:
                onboardingTemplate(media: {
                    VStack {
                        imageView("\(appearance.rawValue)Style")
                        Picker("Appearance Style", selection: $appearance.animation()) {
                            ForEach(Appearance.allCases, id: \.self) { appearance in
                                Text(appearance.rawValue)
                                    .tag(appearance)
                            }
                            
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }
                }, title: "Customize Appearance", description: """
                                   You can choose between two interface styles.
                                   Windows resembles the Snap Layouts interface.
                                   iPadOS resembles the iPad's multi-tasking interface.
                                 """)
            case 3:
                onboardingTemplate(media: {
                    VStack {
                        Button {
                            openURL(snApp.snapShortcut.url)
                        } label: {
                            snapShortcut()
                        }
                        .buttonStyle(.plain)
                        
                        if !snapInstallationStatus {
                            HStack {
                                Button("Install Siri Shortcut") {
                                    openURL(snApp.snapShortcut.url)
                                }
                                .buttonStyle(FrostedButtonStyle(prominence: .increased))
                                
                                Button {
                                    refreshInstallationStatus()
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                }
                                
                                .buttonStyle(FrostedButtonStyle(prominence: .standard))
                            }
                            .padding()
                        } else {
                            Label {
                                Text("Shortcut Is Installed")
                            } icon: {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .font(.title2.bold())
                        }
                    }
                    .onAppear {
                        refreshInstallationStatus()
                    }
                }, title: "Complete Set-Up", description: "To use snApp, you need to install the Snap Siri Shortcut. This lets snApp interact with the system to move windows.")
//            case 4:
//                onboardingTemplate(media: {
//                    imageView("Intro 2")
//                }, title: "Open Settings", description: """
//                                           You can hold down the ⌥ key, to open snApp Settings or close the app.
//                                           ⌘, can also be used to open Settings directly.
//                                           """)
            default:
                EmptyView()
            }
            
            Spacer()
            
            HStack {
                if currentPage > 1 {
                    Button("Previous") {
                        if currentPage > 1 {
                            currentPage -= 1
                        }
                    }
                    .keyboardShortcut(.leftArrow, modifiers: [])
                    .buttonStyle(FrostedButtonStyle())
                }
                
                Group {
                    if currentPage != lastPage {
                        Button("Next") {
                            if currentPage < lastPage {
                                currentPage+=1
                            }
                        }
                        .keyboardShortcut(.rightArrow, modifiers: [])
                    } else {
                        Button("Completed") {
                            completionAction()
                        }
                    }
                }
                .buttonStyle(FrostedButtonStyle(prominence: .increased))
            }
        }
        .padding()
        .padding(.horizontal, 30)
        .animation(.default, value: currentPage)
        .frame(width: 800, height: 550)
    }
    
    func refreshInstallationStatus() {
        snapInstallationStatus = isSnapInstalled()
    }
    
    func snapShortcut() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "rectangle.grid.2x2.fill")
                .imageScale(.large)
            
            Spacer()
            
            Text("Snap")
                .bold()
        }
        .padding(10)
        .foregroundColor(.white)
        .frame(width: 142.1, height: 100, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.gray.gradient)
        }
    }
    
    func imageView(_ name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .shadow(radius: 10)
    }
    
    func onboardingTemplate<Content: View>(media: () -> Content, title: String, description: String) -> some View {
        Group {
            media()
                .frame(minWidth: 400, idealWidth: 600, maxWidth: 600)
                .padding(.horizontal, 30)
            
            Spacer()
            
            VStack(spacing: 5) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .fontWidth(.expanded)
                Text(description)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .transition(.opacity)
    }
}

struct Introduction_Preview: PreviewProvider {
    static var previews: some View {
        Introduction(completionAction: {})
    }
}
