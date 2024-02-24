//
//  FearAndGreedApp.swift
//  FearAndGreed
//
//  Created by IVAN CAMPOS on 2/16/24.
//

import SwiftUI

@main
struct FearAndGreedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .persistentSystemOverlays(.hidden)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.5, height: 0.5, depth: 0.1, in: .meters)
    }
}
