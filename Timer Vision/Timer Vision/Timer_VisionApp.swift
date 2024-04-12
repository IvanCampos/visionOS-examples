//
//  Timer_VisionApp.swift
//  Timer Vision
//
//  Created by IVAN CAMPOS
//

import SwiftUI

@main
struct Timer_VisionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .persistentSystemOverlays(.hidden)
        }
        .windowStyle(.plain)
    }
}
