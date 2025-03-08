//
//  ContentView.swift
//  Music Kit
//
//  Created by IVAN CAMPOS on 3/7/25.
//

import SwiftUI

/// This View now allows the user to enter an artist name,
/// then calls `musicManager.fetchSongsForArtist(artistName:)`.
struct ContentView: View {
    @EnvironmentObject var musicManager: MusicManager
    
    @State private var artistName: String = "XG"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("MusicKit Demo")
                .font(.title)
                .padding(.top, 40)
            
            // TextField to capture any artist name
            HStack {
                TextField("Enter artist name", text: $artistName)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
                
                Button("Fetch Artist Songs") {
                    Task {
                        if musicManager.isAuthorized {
                            musicManager.customSongs.removeAll()
                            await musicManager.fetchSongsForArtist(artistName: artistName)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // Button to show or hide the immersive space
            ToggleImmersiveSpaceButton()
                .padding(.bottom, 40)
            
            Text("Enter an artist above, fetch their songs, then open the immersive space.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
}
