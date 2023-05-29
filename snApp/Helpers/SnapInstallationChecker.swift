//
//  SnapInstallationChecker.swift
//  snApp
//
//  Created by Om Chachad on 23/02/23.
//

import SwiftUI

struct SnapInstallationChecker: View {
    @Environment(\.openURL) var openURL
    @AppStorage("SnapInstalled") var snapIsInstalled = false
    
    @Namespace var nm
    
    var body: some View {
        Group {
            if !snapIsInstalled {
                Label {
                    Text("Snap Shortcut Is Not Installed")
                } icon: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                .matchedGeometryEffect(id: "Install Status", in: nm)
                
                HStack {
                    Button("Install Snap") {
                        openURL(URL(string: snapLink)!)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        withAnimation {
                            refreshInstallationStatus()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .padding(.vertical, 5)
            } else {
                Label {
                    Text("Shortcut Is Installed")
                } icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                .matchedGeometryEffect(id: "Install Status", in: nm)
            }
        }
        .onAppear(perform: refreshInstallationStatus)
    }
    
    func refreshInstallationStatus() {
        snapIsInstalled = isSnapInstalled()
    }
}

struct SnapInstallationChecker_Previews: PreviewProvider {
    static var previews: some View {
        SnapInstallationChecker()
    }
}
