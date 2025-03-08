//
//  Music_KitApp.swift
//  Music Kit
//
//  Created by IVAN CAMPOS on 3/7/25.
//

import SwiftUI

@main
struct Music_KitApp: App {
    
    @State private var appModel = AppModel()
    @StateObject private var musicManager = MusicManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .environmentObject(musicManager)
                .onAppear() {
                    musicManager.requestAuthorization()
                }
        }
        
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .environmentObject(musicManager)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
