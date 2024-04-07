//
//  Plane_DetectionApp.swift
//  Plane Detection
//
//  Created by IVAN CAMPOS on 4/7/24.
//

import SwiftUI

@main
struct Plane_DetectionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
