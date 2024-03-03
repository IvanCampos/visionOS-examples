//
//  HandTrackingApp.swift
//  Hand Tracking
//
//  Created by IVAN CAMPOS on 2/23/24.
//

import SwiftUI

@main
struct HandTrackingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .preferredSurroundingsEffect(.systemDark)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
