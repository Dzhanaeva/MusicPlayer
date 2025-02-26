//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Гидаят Джанаева on 18.11.2024.
//

import SwiftUI

struct PlayerView: View {
    var body: some View {
        ZStack {
            BackgroundColor()
        }
    }
}

#Preview {
    PlayerView()
}

struct BackgroundColor: View {
    var body: some View {
        Color(.white)
            .ignoresSafeArea()
    }
}
