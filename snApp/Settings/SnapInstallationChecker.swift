//
//  SnapInstallationChecker.swift
//  snApp
//
//  Created by Om Chachad on 23/02/23.
//

import SwiftUI

struct SnapInstallationChecker: View {
    @Environment(\.openURL) var openURL
    @AppStorage("SnapInstalled") var snapInstallationStatus = false
    
    @Namespace var nm
    
    var body: some View {
        Group {
            if snapInstallationStatus == false {
                Label {
                    Text("Snap Shortcut Is Not Installed")
                } icon: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                .matchedGeometryEffect(id: "Install Status", in: nm)
                
                HStack {
                    Button("Install Snap") {
                        openURL(URL(string: "https://www.itecheverything.com/snap")!)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        withAnimation {
                            isSnapInstalled()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            } else {
                Label {
                    Text("Shortcut Is Installed")
                } icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                .matchedGeometryEffect(id: "Install Status", in: nm)
            }
        } .onAppear(perform: isSnapInstalled)
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
}

struct SnapInstallationChecker_Previews: PreviewProvider {
    static var previews: some View {
        SnapInstallationChecker()
    }
}
