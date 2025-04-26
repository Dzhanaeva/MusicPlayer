//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by Гидаят Джанаева on 18.11.2024.
//

import SwiftUI

@main
struct MusicPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path())
            PlayerView()
        }
    }
}
