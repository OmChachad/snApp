//
//  FrostedButtonStyle.swift
//  snApp
//
//  Created by Om Chachad on 27/05/23.
//

import Foundation
import SwiftUI

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
