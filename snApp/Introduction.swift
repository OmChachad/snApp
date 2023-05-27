//
//  Introduction.swift
//  snApp
//
//  Created by Om Chachad on 26/05/23.
//

import SwiftUI
import AVKit

struct Introduction: View {
    @AppStorage("AppearanceStyle") var appearance: Appearance = .win11
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL
    let completionAction: () -> Void
    
    @State private var currentPage = 1
    let lastPage = 4
    
    @State private var snapInstallationStatus = false
    
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
                            openURL(URL(string: "https://www.itecheverything.com/snap")!)
                        } label: {
                            snapShortcut()
                        }
                        .buttonStyle(.plain)
                        if !snapInstallationStatus {
                            HStack {
                                Button("Install Siri Shortcut") {
                                    openURL(URL(string: "https://www.itecheverything.com/snap")!)
                                }
                                .buttonStyle(FrostedButtonStyle(prominence: .increased))
                                
                                Button {
                                    isSnapInstalled()
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
                        isSnapInstalled()
                    }
                }, title: "Complete Set-Up", description: "To use snApp, you need to install the Snap Siri Shortcut. This lets snApp interact with the system to move windows.")
            case 4:
                onboardingTemplate(media: {
                    imageView("Intro 2")
                }, title: "Open Settings", description: """
                                           You can hold down the ⌥ key, to open snApp Settings or close the app.
                                           ⌘, can also be used to open Settings directly.
                                           """)
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
    }
    
    func isSnapInstalled() -> Void {
            let task = Process()
            task.launchPath = "/usr/bin/env"
            task.arguments = ["shortcuts", "list"]
            
            let pipe = Pipe()
            task.standardOutput = pipe
            task.launch()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                for i in output.split(separator: "\n") {
                    if i == "Snap" {
                        snapInstallationStatus = true
                        return
                    }
                }
                snapInstallationStatus = false
            } else {
                snapInstallationStatus = false
            }
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

struct FrostedButtonStyle: ButtonStyle {
    var prominence: Prominence = .standard
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .foregroundColor(prominence == .increased ? .white : .primary)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(prominence == .increased ? Color.accentColor.opacity(configuration.isPressed ? 0.2 : 0.8) : Color.primary.opacity(configuration.isPressed ? 0.5 : 0.2))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .shadow(radius: 0.5)
            }
    }
}

struct VideoLooper: View {
    var fileName: String
    var fileExtension: String
    
    var body: some View {
        
        let player = AVPlayer(url: Bundle.main.url(forResource: fileName, withExtension: fileExtension)!)
        
        VideoPlayer(player: player)
            .onAppear {
                player.play()
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
                    if let playerItem = notification.object as? AVPlayerItem {
                        playerItem.seek(to: .zero, completionHandler: nil)
                        player.play()
                    }
                }
            }
    }
}
