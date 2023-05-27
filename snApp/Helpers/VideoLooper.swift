//
//  VideoLooper.swift
//  snApp
//
//  Created by Om Chachad on 27/05/23.
//

import SwiftUI
import AVKit

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
