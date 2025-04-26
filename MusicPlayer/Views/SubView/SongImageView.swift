//
//  SongImageView.swift
//  MusicPlayer
//
//  Created by Гидаят Джанаева on 26.11.2024.
//

import SwiftUI
import UIKit

struct SongImageView: View {
    
    let imageData: Data?
    let size: CGFloat
    
    var body: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
        } else if let defaultImage = UIImage(named: "note") {
            
                Image(uiImage: defaultImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }


#Preview {
    SongImageView(imageData: Data(), size: 200)
}
