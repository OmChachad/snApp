//
//  Introduction.swift
//  snApp
//
//  Created by Om Chachad on 26/05/23.
//

import SwiftUI

struct Introduction: View {
    
    let completionAction: () -> Void
    
    @State private var currentPage = 1
    let lastPage = 2
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            switch(currentPage) {
            case 1:
                onboardingTemplate(imageName: "Intro 1", title: "Welcome to snApp.", description: "Snap, the award winning Siri Shortcut, for incredible window management on macOS, is now available as an app. Quickly re-size and re-arrange windows however you like, inspired by Snap Layouts on Windows.")
            case 2:
                onboardingTemplate(imageName: "Intro 2", title: "Open Settings", description: """
                                           You can hold down the ⌥ key, to open snApp Settings or close the app.
                                           ⌘, can also be used to open Settings directly.
                                           """)
            default:
                onboardingTemplate(imageName: "Intro 1", title: "Welcome to snApp.", description: "Snap, the award winning Siri Shortcut, for incredible window management on macOS, is now available as an app. Quickly re-size and re-arrange windows however you like, inspired by Snap Layouts on Windows.")
            }
            
            
            Spacer()
            
            
            HStack {
                if currentPage > 1 {
                    Button("Previous") {
                        currentPage -= 1
                    }
                    .keyboardShortcut(.leftArrow, modifiers: [])
                }
                
                Group {
                    if currentPage != lastPage {
                        Button("Next") {
                            currentPage+=1
                        }
                        .keyboardShortcut(.rightArrow, modifiers: [])
                    } else {
                        Button("Completed") {
                            completionAction()
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .padding(.horizontal, 30)
        .visualEffect(material: .underWindowBackground)
        .animation(.default, value: currentPage)
    }
    
    func onboardingTemplate(imageName: String, title: String, description: String) -> some View {
        Group {
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(radius: 10)
            
            
            Spacer()
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .fontWidth(.expanded)
            Text(description)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
        }
        .transition(.opacity)
    }
}

struct VisualEffectBackground: NSViewRepresentable {
    private let material: NSVisualEffectView.Material
    private let blendingMode: NSVisualEffectView.BlendingMode
    private let isEmphasized: Bool
    
    fileprivate init(
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode,
        emphasized: Bool) {
            self.material = material
            self.blendingMode = blendingMode
            self.isEmphasized = emphasized
        }
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        
        // Not certain how necessary this is
        view.autoresizingMask = [.width, .height]
        
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.isEmphasized = isEmphasized
    }
}

extension View {
    func visualEffect(
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        emphasized: Bool = false
    ) -> some View {
        background(
            VisualEffectBackground(
                material: material,
                blendingMode: blendingMode,
                emphasized: emphasized
            )
        )
    }
}
