//
//  bsky_3DApp.swift
//  bsky 3D
//
//  Created by IVAN CAMPOS on 11/25/24.
//

import SwiftUI

@main
struct bsky_3DApp: App {

    @State private var appModel = AppModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        .windowStyle(.plain)
        .persistentSystemOverlays(.hidden)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
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
