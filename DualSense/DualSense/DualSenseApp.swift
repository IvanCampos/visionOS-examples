//
//  DualSenseApp.swift
//  DualSense
//
//  Created by IVAN CAMPOS on 1/12/25.
//

import SwiftUI

@main
struct DualSenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .handlesGameControllerEvents(matching: .gamepad)
        }
    }
}
