//
//  SongCell.swift
//  MusicPlayer
//
//  Created by Гидаят Джанаева on 18.11.2024.
//

import SwiftUI

struct SongCell: View {
    
    let song: SongModel
    let durationFormatted: (TimeInterval) -> String
    
    var body: some View {
        HStack {
            
            SongImageView(imageData: song.coverImage, size: 60)
            
            VStack(alignment: .leading) {
                Text(song.name)
                    .nameFont()
                Text(song.artist ?? "Unknown")
                    .artistFont()
            }
            Spacer()
            
            if let duration = song.duration {
                Text(durationFormatted(duration))
                    .artistFont()
            }

        }
        .listRowBackground(Color.clear)
    }
}

#Preview {
    PlayerView()
}
