//
//  ultraThinPresentationBackground.swift
//  snApp
//
//  Created by Om Chachad on 2/28/25.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func ultraThinPresentationBackground() -> some View {
        if #available(macOS 13.3, *) {
            self
                .presentationBackground(.ultraThickMaterial)
        } else {
            self
        }
    }
}
