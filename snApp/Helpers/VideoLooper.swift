//
//  VideoLooper.swift
//  snApp
//
//  Created by Om Chachad on 27/05/23.
//

import SwiftUI
import SVEVideoUI

struct VideoLooper: View {
    var fileName: String
    var fileExtension: String
    
    @State private var isPlaying = true
    var body: some View {
        let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension)!
        
        Video(url: url, playing: $isPlaying)
            .playbackControls(false)
        
            .onChange(of: isPlaying) { newValue in
                isPlaying = true
            }
    }
}
