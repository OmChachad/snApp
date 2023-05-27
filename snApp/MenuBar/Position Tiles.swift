//
//  Position Tiles.swift
//  snApp
//
//  Created by Om Chachad on 27/05/23.
//

import SwiftUI

enum Orientation {
    case vertical
    case horizontal
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
